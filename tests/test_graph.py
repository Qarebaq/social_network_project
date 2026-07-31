"""
Tests for the Graph domain model.

This module contains tests for core graph operations such as adding users,
removing users, adding friendships, removing friendships, and validating graph
state.
"""

import pytest

from graph.domain.graph import Graph
from graph.exceptions.graph_exceptions import (
    UserNotFoundException,
    DuplicateUserException,
    FriendshipNotFoundException,
    DuplicateFriendshipException,
    SelfFriendshipException,
)


def make_graph_with_users(*user_ids):
    """Helper: build a graph with the given user ids (name = same as id)."""
    graph = Graph()
    for user_id in user_ids:
        graph.add_user(user_id, user_id)
    return graph


def test_add_user():
    graph = Graph()
    user = graph.add_user("A", "Ali")
    assert graph.has_user("A")
    assert user.get_id() == "A"
    assert user.get_name() == "Ali"
    assert graph.get_user_count() == 1


def test_add_duplicate_user():
    graph = make_graph_with_users("A")
    with pytest.raises(DuplicateUserException):
        graph.add_user("A", "Another Name")


def test_remove_user():
    graph = make_graph_with_users("A")
    graph.remove_user("A")
    assert not graph.has_user("A")
    assert graph.get_user_count() == 0


def test_remove_user_also_removes_friendships():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")

    graph.remove_user("A")

    assert not graph.has_user("A")
    assert graph.get_friends("B") == []
    assert graph.get_friends("C") == []
    assert graph.get_friendship_count() == 0


def test_update_user():
    graph = make_graph_with_users("A")
    graph.update_user("A", "New Name")
    assert graph.get_user("A").get_name() == "New Name"


def test_get_user():
    graph = make_graph_with_users("A")
    user = graph.get_user("A")
    assert user is not None
    assert user.get_id() == "A"
    assert graph.get_user("missing") is None


def test_has_user():
    graph = make_graph_with_users("A")
    assert graph.has_user("A") is True
    assert graph.has_user("B") is False


def test_get_users():
    graph = make_graph_with_users("A", "B")
    ids = sorted(u.get_id() for u in graph.get_users())
    assert ids == ["A", "B"]


def test_get_user_count():
    graph = Graph()
    assert graph.get_user_count() == 0
    graph.add_user("A", "Ali")
    graph.add_user("B", "Sara")
    assert graph.get_user_count() == 2


def test_add_friendship():
    graph = make_graph_with_users("A", "B")
    friendship = graph.add_friendship("A", "B")
    assert graph.has_friendship("A", "B")
    assert friendship.contains_user("A")
    assert friendship.contains_user("B")
    assert graph.get_friendship_count() == 1


def test_add_duplicate_friendship():
    graph = make_graph_with_users("A", "B")
    graph.add_friendship("A", "B")
    with pytest.raises(DuplicateFriendshipException):
        graph.add_friendship("A", "B")
    # order shouldn't matter either
    with pytest.raises(DuplicateFriendshipException):
        graph.add_friendship("B", "A")


def test_add_self_friendship():
    graph = make_graph_with_users("A")
    with pytest.raises(SelfFriendshipException):
        graph.add_friendship("A", "A")


def test_add_friendship_with_missing_user():
    graph = make_graph_with_users("A")
    with pytest.raises(UserNotFoundException):
        graph.add_friendship("A", "missing")


def test_remove_friendship():
    graph = make_graph_with_users("A", "B")
    graph.add_friendship("A", "B")
    graph.remove_friendship("A", "B")
    assert not graph.has_friendship("A", "B")
    assert graph.get_friendship_count() == 0


def test_remove_friendship_not_found():
    graph = make_graph_with_users("A", "B")
    with pytest.raises(FriendshipNotFoundException):
        graph.remove_friendship("A", "B")


def test_has_friendship():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    assert graph.has_friendship("A", "B") is True
    assert graph.has_friendship("B", "A") is True  # undirected
    assert graph.has_friendship("A", "C") is False


def test_get_friends():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")
    friend_ids = sorted(u.get_id() for u in graph.get_friends("A"))
    assert friend_ids == ["B", "C"]
    assert graph.get_friends("B") == [graph.get_user("A")]


def test_get_neighbors():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")
    assert sorted(graph.get_neighbors("A")) == ["B", "C"]


def test_get_friendships():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")
    assert len(graph.get_friendships()) == 2


def test_get_friendship_count():
    graph = make_graph_with_users("A", "B", "C")
    assert graph.get_friendship_count() == 0
    graph.add_friendship("A", "B")
    assert graph.get_friendship_count() == 1
    graph.add_friendship("A", "C")
    assert graph.get_friendship_count() == 2
    graph.remove_friendship("A", "B")
    assert graph.get_friendship_count() == 1


def test_get_degree():
    graph = make_graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("A", "C")
    assert graph.get_degree("A") == 2
    assert graph.get_degree("B") == 1


def test_clear_graph():
    graph = make_graph_with_users("A", "B")
    graph.add_friendship("A", "B")
    graph.clear()
    assert graph.get_user_count() == 0
    assert graph.get_friendship_count() == 0
    assert graph.is_empty()


def test_is_empty():
    graph = Graph()
    assert graph.is_empty() is True
    graph.add_user("A", "Ali")
    assert graph.is_empty() is False