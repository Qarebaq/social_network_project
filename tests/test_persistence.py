import json

import pytest

from graph.domain.graph import Graph
from graph.exceptions.graph_exceptions import InvalidGraphDataException
from persistence.json_graph_repository import JsonGraphRepository


def build_graph():
    graph = Graph()
    graph.add_user("A", "Ali")
    graph.add_user("B", "Bahar")
    graph.add_user("C", "Cyrus")
    graph.add_friendship("A", "B", 1)
    graph.add_friendship("B", "C", 2)
    return graph


def test_save_load_round_trip_preserves_users_and_friendships(tmp_path):
    repository = JsonGraphRepository()
    path = tmp_path / "nested" / "network.json"

    repository.save(build_graph(), path)
    loaded = repository.load(path)

    assert repository.exists(path)
    assert {user.get_id(): user.get_name() for user in loaded.get_users()} == {
        "A": "Ali",
        "B": "Bahar",
        "C": "Cyrus",
    }
    assert loaded.get_friendship_count() == 2
    assert {
        (
            friendship.get_user1_id(),
            friendship.get_user2_id(),
            friendship.get_weight(),
        )
        for friendship in loaded.get_friendships()
    } == {("A", "B", 1), ("B", "C", 2)}


def test_load_missing_file_raises_project_exception(tmp_path):
    with pytest.raises(InvalidGraphDataException, match="not found"):
        JsonGraphRepository().load(tmp_path / "missing.json")


def test_load_invalid_json_raises_project_exception(tmp_path):
    path = tmp_path / "invalid.json"
    path.write_text("{not-json", encoding="utf-8")

    with pytest.raises(InvalidGraphDataException, match="not valid JSON"):
        JsonGraphRepository().load(path)


@pytest.mark.parametrize(
    "data",
    [
        [],
        {"users": []},
        {"users": {}, "friendships": []},
        {
            "users": [{"id": "A", "name": "Ali"}],
            "friendships": [
                {"user1_id": "A", "user2_id": "missing", "weight": 1}
            ],
        },
    ],
)
def test_load_invalid_graph_data_raises_project_exception(tmp_path, data):
    path = tmp_path / "invalid-data.json"
    path.write_text(json.dumps(data), encoding="utf-8")

    with pytest.raises(InvalidGraphDataException):
        JsonGraphRepository().load(path)
