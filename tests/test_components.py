import pytest

from graph.domain.graph import Graph
from graph.exceptions.graph_exceptions import UserNotFoundException
from graph.facade import GraphFacade
from graph.services.component_service import ComponentService


def build_graph(user_ids, friendships=()):
    graph = Graph()
    for user_id in user_ids:
        graph.add_user(user_id, f"User {user_id}")
    for user1_id, user2_id in friendships:
        graph.add_friendship(user1_id, user2_id)
    return graph


def component_member_sets(components):
    return {frozenset(component.get_members()) for component in components}


def test_empty_graph_components():
    service = ComponentService()

    assert service.get_components(Graph()) == []
    assert service.get_largest_components(Graph()) == []
    assert service.count_components(Graph()) == 0


def test_single_user_component():
    graph = build_graph(["A"])
    components = ComponentService().get_components(graph)

    assert len(components) == 1
    assert components[0].get_members() == ["A"]
    assert components[0].get_size() == 1
    assert components[0].contains("A")


def test_one_connected_component():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C"), ("C", "D")]
    )

    assert component_member_sets(ComponentService().get_components(graph)) == {
        frozenset({"A", "B", "C", "D"})
    }


def test_multiple_connected_components_include_isolated_users():
    graph = build_graph(
        ["A", "B", "C", "D", "E", "F"],
        [("A", "B"), ("B", "C"), ("D", "E")]
    )
    service = ComponentService()

    components = service.get_components(graph)
    assert service.count_components(graph) == 3
    assert component_member_sets(components) == {
        frozenset({"A", "B", "C"}),
        frozenset({"D", "E"}),
        frozenset({"F"})
    }


def test_largest_component():
    graph = build_graph(
        ["A", "B", "C", "D", "E"],
        [("A", "B"), ("B", "C"), ("D", "E")]
    )

    largest = ComponentService().get_largest_components(graph)
    assert component_member_sets(largest) == {frozenset({"A", "B", "C"})}


def test_equal_size_largest_components():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("C", "D")]
    )

    largest = ComponentService().get_largest_components(graph)
    assert component_member_sets(largest) == {
        frozenset({"A", "B"}),
        frozenset({"C", "D"})
    }


def test_component_with_cycle_does_not_repeat_members():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C"), ("C", "A")]
    )

    components = ComponentService().get_components(graph)
    assert component_member_sets(components) == {
        frozenset({"A", "B", "C"}),
        frozenset({"D"})
    }
    assert sum(component.get_size() for component in components) == 4


def test_component_of_user():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C")]
    )

    component = ComponentService().get_component_of_user(graph, "B")
    assert set(component.get_members()) == {"A", "B", "C"}


def test_component_of_isolated_user():
    graph = build_graph(["A", "B"], [("A", "B")])
    graph.add_user("C", "User C")

    component = ComponentService().get_component_of_user(graph, "C")
    assert component.get_members() == ["C"]


def test_component_of_unknown_user_raises_domain_error():
    graph = build_graph(["A"])

    with pytest.raises(UserNotFoundException):
        ComponentService().get_component_of_user(graph, "missing")


def test_facade_component_results_match_service_results():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C")]
    )
    facade = GraphFacade(graph)
    service = ComponentService()

    assert component_member_sets(facade.get_components()) == component_member_sets(
        service.get_components(graph)
    )
    assert component_member_sets(
        facade.get_largest_components()
    ) == component_member_sets(service.get_largest_components(graph))
