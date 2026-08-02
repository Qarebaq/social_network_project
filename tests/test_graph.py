"""
Tests for the Graph domain model.

This module contains tests for core graph operations such as adding users,
removing users, adding friendships, removing friendships, and validating graph
state.
"""

import pytest

from graph.domain.graph import Graph
from graph.exceptions.graph_exceptions import (
    DuplicateFriendshipException,
    DuplicateUserException,
    SelfFriendshipException,
)


def create_graph_with_users(*user_ids):
    graph = Graph()
    for user_id in user_ids:
        graph.add_user(user_id, f"User {user_id}")
    return graph


def test_add_user():
    graph = Graph()
    user = graph.add_user("A", "Alice")

    assert user.get_id() == "A"
    assert graph.get_user("A") == user


def test_add_duplicate_user():
    graph = create_graph_with_users("A")

    with pytest.raises(DuplicateUserException):
        graph.add_user("A", "Another Alice")


def test_remove_user():
    graph = create_graph_with_users("A")

    removed_user = graph.remove_user("A")

    assert removed_user.get_id() == "A"
    assert not graph.has_user("A")


def test_remove_user_also_removes_friendships():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("B", "C")

    graph.remove_user("B")

    assert graph.get_friendship_count() == 0
    assert graph.get_neighbors("A") == []
    assert graph.get_neighbors("C") == []


def test_update_user():
    graph = create_graph_with_users("A")

    updated_user = graph.update_user("A", "Alice")

    assert updated_user.get_name() == "Alice"
    with pytest.raises(ValueError):
        graph.update_user("A", "   ")
    assert graph.get_user("A").get_name() == "Alice"


def test_get_user():
    graph = create_graph_with_users("A")

    assert graph.get_user("A").get_id() == "A"


def test_has_user():
    graph = create_graph_with_users("A")

    assert graph.has_user("A")
    assert not graph.has_user("missing")


def test_get_users():
    graph = create_graph_with_users("A", "B")

    assert [user.get_id() for user in graph.get_users()] == ["A", "B"]


def test_get_user_count():
    graph = create_graph_with_users("A", "B")

    assert graph.get_user_count() == 2


def test_add_friendship():
    graph = create_graph_with_users("A", "B")

    friendship = graph.add_friendship("A", "B", weight=3)

    assert friendship.get_weight() == 3
    assert graph.has_friendship("A", "B")


def test_add_duplicate_friendship():
    graph = create_graph_with_users("A", "B")
    graph.add_friendship("A", "B")

    with pytest.raises(DuplicateFriendshipException):
        graph.add_friendship("B", "A")


def test_add_self_friendship():
    graph = create_graph_with_users("A")

    with pytest.raises(SelfFriendshipException):
        graph.add_friendship("A", "A")


def test_remove_friendship():
    graph = create_graph_with_users("A", "B")
    graph.add_friendship("A", "B")

    removed_friendship = graph.remove_friendship("A", "B")

    assert removed_friendship.connects("A", "B")
    assert not graph.has_friendship("A", "B")


def test_has_friendship():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")

    assert graph.has_friendship("A", "B")
    assert graph.has_friendship("B", "A")
    assert not graph.has_friendship("A", "C")


def test_get_friends():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")

    assert [user.get_id() for user in graph.get_friends("A")] == ["B", "C"]


def test_get_neighbors():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")

    assert graph.get_neighbors("A") == ["B", "C"]


def test_get_friendships():
    graph = create_graph_with_users("A", "B", "C")
    first = graph.add_friendship("A", "B")
    second = graph.add_friendship("B", "C")

    assert graph.get_friendships() == [first, second]


def test_get_friendship_count():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("B", "C")

    assert graph.get_friendship_count() == 2


def test_get_degree():
    graph = create_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")

    assert graph.get_degree("A") == 2
    assert graph.get_degree("B") == 1


def test_clear_graph():
    graph = create_graph_with_users("A", "B")
    graph.add_friendship("A", "B")

    graph.clear()

    assert graph.get_user_count() == 0
    assert graph.get_friendship_count() == 0


def test_is_empty():
    graph = Graph()

    assert graph.is_empty()
    graph.add_user("A", "Alice")
    assert not graph.is_empty()
