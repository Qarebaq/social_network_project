"""
Tests for distance analysis operations.

This module tests:
- BFS distance calculation
- unreachable users
- distance from user to itself
- sorted distances
- empty graph behavior
- invalid user validation
"""

import pytest

from graph.domain.graph import Graph
from graph.services.distance_service import DistanceService


def create_graph_with_users(*user_ids):
    graph = Graph()

    for user_id in user_ids:
        graph.add_user(user_id, f"User {user_id}")

    return graph


def test_distances_from_user():
    """
    Graph:
        1 -- 2 -- 3

    Expected:
        1 -> 2 = 1
        1 -> 3 = 2
    """

    graph = create_graph_with_users(1, 2, 3)

    graph.add_friendship(1, 2)
    graph.add_friendship(2, 3)

    service = DistanceService()

    report = service.get_distances_from_user(graph, 1)

    assert report.get_distances() == {
        2: 1,
        3: 2
    }


def test_distance_to_unreachable_users():
    """
    Graph:
        1 -- 2

        3

    User 3 is unreachable from user 1.
    """

    graph = create_graph_with_users(1, 2, 3)

    graph.add_friendship(1, 2)

    service = DistanceService()

    report = service.get_distances_from_user(graph, 1)

    assert report.get_unreachable_users() == [3]


def test_distance_from_user_to_self():
    """
    Source user should not appear in distances.
    """

    graph = create_graph_with_users(1, 2)

    graph.add_friendship(1, 2)

    service = DistanceService()

    report = service.get_distances_from_user(graph, 1)

    assert 1 not in report.get_distances()
    assert report.get_distance_to(1) == -1


def test_sorted_distances():
    """
    Distances should be sorted by distance value.
    """

    graph = create_graph_with_users(1, 2, 3, 4)

    graph.add_friendship(1, 2)
    graph.add_friendship(1, 3)
    graph.add_friendship(3, 4)

    service = DistanceService()

    sorted_distances = service.get_sorted_distances_from_user(graph, 1)

    assert sorted_distances == [
        (2, 1),
        (3, 1),
        (4, 2)
    ]


def test_distances_empty_graph():
    """
    Requesting distance from non-existing user
    should raise validation error.
    """

    graph = Graph()

    service = DistanceService()

    with pytest.raises(Exception):
        service.get_distances_from_user(graph, 1)


def test_invalid_user_distance():
    """
    Distance calculation should reject unknown users.
    """

    graph = create_graph_with_users(1, 2)

    service = DistanceService()

    with pytest.raises(Exception):
        service.get_distances_from_user(graph, 99)