import pytest

from graph.domain.graph import Graph
from graph.exceptions.graph_exceptions import (
    DuplicateFriendshipException, DuplicateUserException,
    FriendshipNotFoundException, SelfFriendshipException, UserNotFoundException,
)


def graph_with_users(*ids):
    graph = Graph()
    for user_id in ids:
        graph.add_user(user_id, f"User {user_id}")
    return graph


def test_user_crud_and_queries():
    graph = graph_with_users("A", "B")
    assert graph.get_user("A").get_name() == "User A"
    assert [user.get_id() for user in graph.get_users()] == ["A", "B"]
    assert graph.has_user("B") and graph.get_user_count() == 2
    graph.update_user("A", "Alice")
    assert graph.get_user("A").get_name() == "Alice"
    assert graph.remove_user("B").get_id() == "B"


def test_duplicate_and_missing_users_raise_domain_exceptions():
    graph = graph_with_users("A")
    with pytest.raises(DuplicateUserException):
        graph.add_user("A", "Again")
    with pytest.raises(UserNotFoundException):
        graph.get_user("missing")


def test_invalid_update_does_not_mutate_user():
    graph = graph_with_users("A")

    with pytest.raises(ValueError):
        graph.update_user("A", "   ")

    assert graph.get_user("A").get_name() == "User A"


def test_friendship_contracts():
    graph = graph_with_users("A", "B", "C")
    friendship = graph.add_friendship("A", "B", weight=3)
    graph.add_friendship("A", "C")
    assert friendship.get_weight() == 3
    assert graph.has_friendship("B", "A")
    assert graph.get_neighbors("A") == ["B", "C"]
    assert [user.get_id() for user in graph.get_friends("A")] == ["B", "C"]
    assert graph.get_degree("A") == 2
    assert graph.get_friendship_count() == 2
    assert len(graph.get_friendships()) == 2


def test_invalid_friendships_raise_domain_exceptions():
    graph = graph_with_users("A", "B")
    with pytest.raises(SelfFriendshipException):
        graph.add_friendship("A", "A")
    graph.add_friendship("A", "B")
    with pytest.raises(DuplicateFriendshipException):
        graph.add_friendship("B", "A")
    with pytest.raises(FriendshipNotFoundException):
        graph.remove_friendship("A", "A")


def test_removing_user_removes_incident_friendships():
    graph = graph_with_users("A", "B", "C")
    graph.add_friendship("A", "B")
    graph.add_friendship("B", "C")
    graph.remove_user("B")
    assert graph.get_friendship_count() == 0
    assert graph.get_neighbors("A") == []


def test_clear_and_empty_state():
    graph = graph_with_users("A", "B")
    graph.add_friendship("A", "B")
    assert not graph.is_empty()
    graph.clear()
    assert graph.is_empty()
    assert graph.get_user_count() == graph.get_friendship_count() == 0
