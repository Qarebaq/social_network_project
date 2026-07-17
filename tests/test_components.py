from graph.domain.graph import Graph
from graph.services.component_service import ComponentService
""" Tests for connected component operations. This module contains tests for detecting connected components, largest components, isolated users, empty graphs, cyclic graphs, and multiple separate groups. """

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
    # test graph with no users
    service = ComponentService()
    assert service.get_components(Graph()) == []
    assert service.count_components(Graph()) == 0


def test_single_user_component():
    #  test graph with one isolated user
    graph = build_graph(["A"])
    components = ComponentService().get_components(graph)

    assert len(components) == 1
    assert components[0].get_members() == ["A"]
    assert components[0].get_size() == 1
    assert components[0].contains("A")


def test_one_connected_component():
    # test graph where all users are connected
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C"), ("C", "D")]
    )
    components = ComponentService().get_components(graph)
    assert component_member_sets(components) == {frozenset({"A", "B", "C", "D"})}


def test_multiple_connected_components():
    # test graph with multiple separate groups
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
    #  test largest component detection
    graph = build_graph(
        ["A", "B", "C", "D", "E"],
        [("A", "B"), ("B", "C"), ("D", "E")]
    )

    largest = ComponentService().get_largest_components(graph)
    assert component_member_sets(largest) == {frozenset({"A", "B", "C"})}



def test_equal_size_largest_components():
    #  test when multiple components have same max size
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("C", "D")]
    )

    largest = ComponentService().get_largest_components(graph)
    assert component_member_sets(largest) == {
        frozenset({"A", "B"}),
        frozenset({"C", "D"})
    }


def test_component_with_cycle():
    #  test DFS/BFS does not loop forever in cycle
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C"), ("C", "A")]
    )
    service = ComponentService()

    components = service.get_components(graph)
    assert component_member_sets(components) == {
        frozenset({"A", "B", "C"}),
        frozenset({"D"})
    }

def test_component_of_user():
    graph = build_graph(
        ["A", "B", "C", "D"],
        [("A", "B"), ("B", "C")]
    )

    component = ComponentService().get_component_of_user(graph, "B")
    assert set(component.get_members()) == {"A", "B", "C"}