from graph.domain.graph import Graph
from graph.services.statistics_service import StatisticsService
import pytest
""" Tests for network statistics operations. This module contains tests for total users, total friendships, average degree, most connected users, largest components, and complete network statistics reports. """

def build_graph(user_ids, friendships=()):
    graph = Graph()
    for user_id in user_ids:
        graph.add_user(user_id, f"User {user_id}")
    for user1_id, user2_id in friendships:
        graph.add_friendship(user1_id, user2_id)
    return graph




def test_total_users():
    graph = build_graph(["A", "B", "C"])
    assert StatisticsService().get_total_users(graph) == 3


def test_total_friendships():
    graph = build_graph(["A", "B", "C"], [("A", "B"), ("B", "C")])
    assert StatisticsService().get_total_friendships(graph) == 2


def test_average_degree():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C"), ("C", "D")]
    )
    assert StatisticsService().get_average_degree(graph) == pytest.approx(1.5)


def test_average_degree_empty_graph():
    assert StatisticsService().get_average_degree(Graph()) == 0.0


def test_most_connected_users():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("A", "C"), ("A", "D"), ("B", "C")]
    )
    service = StatisticsService()

    assert service.get_most_connected_users(graph) == ["A"]
    assert service.get_maximum_degree(graph) == 3


def test_most_connected_users_tie():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("C", "D")]
    )

    assert set(StatisticsService().get_most_connected_users(graph)) == {
        "A", "B", "C", "D"
    }


def test_empty_graph_has_no_most_connected_user():
    service = StatisticsService()
    assert service.get_most_connected_users(Graph()) == []
    assert service.get_maximum_degree(Graph()) == 0


def test_graph_info():
    graph = build_graph(
        ["A", "B", "C", "D", "E"],
        [("A", "B"), ("B", "C"), ("D", "E")]
    )

    info = StatisticsService().get_graph_info(graph)

    assert info.get_total_users() == 5
    assert info.get_total_friendships() == 3
    assert info.get_average_degree() == pytest.approx(1.2)
    assert info.get_maximum_degree() == 2
    assert info.get_most_connected_users() == ["B"]
    assert len(info.get_largest_components()) == 1
    assert set(info.get_largest_components()[0].get_members()) == {"A", "B", "C"}
