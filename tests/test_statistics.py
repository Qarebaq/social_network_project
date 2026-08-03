import pytest

from graph.domain.graph import Graph
from graph.facade import GraphFacade
from graph.services.statistics_service import StatisticsService


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


def test_all_isolated_users_tie_at_zero_degree():
    graph = build_graph(["A", "B", "C"])
    service = StatisticsService()

    assert set(service.get_most_connected_users(graph)) == {"A", "B", "C"}
    assert service.get_maximum_degree(graph) == 0


def test_empty_graph_statistics_are_well_defined():
    service = StatisticsService()
    info = service.get_graph_info(Graph())

    assert info.get_total_users() == 0
    assert info.get_total_friendships() == 0
    assert info.get_average_degree() == 0.0
    assert info.get_maximum_degree() == 0
    assert info.get_most_connected_users() == []
    assert info.get_largest_components() == []


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


def test_facade_statistics_match_service_results():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("A", "C")]
    )
    facade = GraphFacade(graph)
    service_info = StatisticsService().get_graph_info(graph)
    facade_info = facade.get_graph_statistics()

    assert facade_info.get_total_users() == service_info.get_total_users()
    assert facade_info.get_total_friendships() == service_info.get_total_friendships()
    assert facade_info.get_average_degree() == service_info.get_average_degree()
    assert facade_info.get_maximum_degree() == service_info.get_maximum_degree()
    assert facade_info.get_most_connected_users() == service_info.get_most_connected_users()
    assert {
        frozenset(component.get_members())
        for component in facade_info.get_largest_components()
    } == {
        frozenset(component.get_members())
        for component in service_info.get_largest_components()
    }
