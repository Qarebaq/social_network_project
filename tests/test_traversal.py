import pytest

from graph.domain.graph import Graph
from graph.services.traversal_service import TraversalService


def build_graph():
    graph = Graph()
    for user_id in "ABCDE":
        graph.add_user(user_id, user_id)
    for edge in (("A", "B"), ("A", "C"), ("B", "D")):
        graph.add_friendship(*edge)
    return graph


def ids(users):
    return [user.get_id() for user in users]


def test_bfs_and_dfs_are_deterministic():
    graph = build_graph()
    service = TraversalService()
    assert ids(service.bfs(graph, "A")) == ["A", "B", "C", "D"]
    assert ids(service.dfs(graph, "A")) == ["A", "B", "D", "C"]


def test_connected_disconnected_and_same_user():
    graph = build_graph()
    service = TraversalService()
    assert service.is_connected(graph, "A", "D")
    assert not service.is_connected(graph, "A", "E")
    assert service.is_connected(graph, "A", "A")


def test_missing_start_user_is_rejected():
    with pytest.raises(ValueError):
        TraversalService().bfs(build_graph(), "missing")
