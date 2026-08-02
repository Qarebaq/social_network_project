import pytest

from graph.domain.graph import Graph
from graph.services.shortest_path_service import ShortestPathService


def build_graph():
    graph = Graph()
    for user_id in "ABCDE":
        graph.add_user(user_id, user_id)
    for edge in (("A", "B"), ("B", "C"), ("A", "D"), ("D", "C")):
        graph.add_friendship(*edge)
    return graph


def test_shortest_path_result_has_complete_contract():
    result = ShortestPathService().find_shortest_path(build_graph(), "A", "C")
    assert result.get_source_user_id() == "A"
    assert result.get_target_user_id() == "C"
    assert [user.get_id() for user in result.get_path()] == ["A", "B", "C"]
    assert result.get_distance() == 2
    assert result.path_exists()


def test_unreachable_path():
    result = ShortestPathService().find_shortest_path(build_graph(), "A", "E")
    assert result.get_path() == []
    assert result.get_distance() == -1
    assert not result.path_exists()


def test_path_from_user_to_itself():
    result = ShortestPathService().find_shortest_path(build_graph(), "A", "A")
    assert [user.get_id() for user in result.get_path()] == ["A"]
    assert result.get_distance() == 0 and result.path_exists()


def test_distance_and_has_path_helpers():
    graph = build_graph()
    service = ShortestPathService()
    assert service.get_distance_between(graph, "A", "C") == 2
    assert service.has_path(graph, "A", "C")
    assert not service.has_path(graph, "A", "E")


@pytest.mark.parametrize(
    ("source_user_id", "target_user_id"),
    (("missing", "A"), ("A", "missing")),
)
def test_missing_user_is_rejected(source_user_id, target_user_id):
    with pytest.raises(ValueError):
        ShortestPathService().find_shortest_path(
            build_graph(), source_user_id, target_user_id
        )
