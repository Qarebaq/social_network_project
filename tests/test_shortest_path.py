import pytest

from graph.domain.graph import Graph
from graph.services.shortest_path_service import ShortestPathService

""" Tests for the Graph domain model. This module contains tests for core graph operations such as adding users, removing users, adding friendships, removing friendships, and validating graph state. """


def create_shortest_path_graph():
    graph = Graph()
    for user_id in "ABCDE":
        graph.add_user(user_id, user_id)
    for user1_id, user2_id in (
        ("A", "B"),
        ("B", "C"),
        ("A", "D"),
        ("D", "C"),
    ):
        graph.add_friendship(user1_id, user2_id)
    return graph


def test_shortest_path_exists():
    result = ShortestPathService().find_shortest_path(
        create_shortest_path_graph(), "A", "C"
    )

    assert result.path_exists()
    assert [user.get_id() for user in result.get_path()] == ["A", "B", "C"]
    assert result.get_source_user_id() == "A"
    assert result.get_target_user_id() == "C"


def test_shortest_path_not_exists():
    result = ShortestPathService().find_shortest_path(
        create_shortest_path_graph(), "A", "E"
    )

    assert not result.path_exists()
    assert result.get_path() == []
    assert result.get_distance() == -1


def test_shortest_path_same_user():
    result = ShortestPathService().find_shortest_path(
        create_shortest_path_graph(), "A", "A"
    )

    assert result.path_exists()
    assert [user.get_id() for user in result.get_path()] == ["A"]
    assert result.get_distance() == 0


def test_shortest_path_distance():
    graph = create_shortest_path_graph()
    service = ShortestPathService()

    assert service.get_distance_between(graph, "A", "C") == 2
    assert service.has_path(graph, "A", "C")
    assert not service.has_path(graph, "A", "E")


def test_multiple_shortest_paths():
    result = ShortestPathService().find_shortest_path(
        create_shortest_path_graph(), "A", "C"
    )

    assert [user.get_id() for user in result.get_path()] in (
        ["A", "B", "C"],
        ["A", "D", "C"],
    )
    assert result.get_distance() == 2


@pytest.mark.parametrize(
    ("source_user_id", "target_user_id"),
    (("missing", "A"), ("A", "missing")),
)
def test_shortest_path_rejects_missing_users(source_user_id, target_user_id):
    with pytest.raises(ValueError):
        ShortestPathService().find_shortest_path(
            create_shortest_path_graph(), source_user_id, target_user_id
        )
