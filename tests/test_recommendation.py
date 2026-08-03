"""
Tests for friend recommendation operations.

This module contains tests for friend suggestions, mutual-friend scoring,
excluding current friends, excluding the selected user, and cases with no
valid recommendations.
"""

from graph.domain.graph import Graph
from graph.services.recommendation_service import RecommendationService


def create_graph():
    graph = Graph()

    graph.add_user(1, "Alice")
    graph.add_user(2, "Bob")
    graph.add_user(3, "Charlie")
    graph.add_user(4, "David")

    return graph


def test_suggest_friends():
    graph = create_graph()

    graph.add_friendship(1, 2)
    graph.add_friendship(2, 3)

    service = RecommendationService()

    suggestions = service.suggest_friends(graph, 1)

    assert len(suggestions) == 1
    assert suggestions[0].get_suggested_user_id() == 3
    assert suggestions[0].get_score() == 1


def test_suggest_friends_no_candidates():
    graph = create_graph()

    graph.add_friendship(1, 2)

    service = RecommendationService()

    suggestions = service.suggest_friends(graph, 1)

    assert suggestions == []


def test_suggest_friends_excludes_current_friends():
    graph = create_graph()

    graph.add_friendship(1, 2)
    graph.add_friendship(1, 3)
    graph.add_friendship(2, 3)

    service = RecommendationService()

    suggestions = service.suggest_friends(graph, 1)

    ids = [s.get_suggested_user_id() for s in suggestions]

    assert 2 not in ids
    assert 3 not in ids
    assert suggestions == []


def test_suggest_friends_excludes_self():
    graph = create_graph()

    graph.add_friendship(1, 2)
    graph.add_friendship(2, 3)

    service = RecommendationService()

    suggestions = service.suggest_friends(graph, 1)

    ids = [s.get_suggested_user_id() for s in suggestions]

    assert 1 not in ids


def test_suggestion_score_by_mutual_friends():
    graph = create_graph()

    graph.add_friendship(1, 2)
    graph.add_friendship(1, 3)
    graph.add_friendship(2, 4)
    graph.add_friendship(3, 4)

    service = RecommendationService()

    suggestions = service.suggest_friends(graph, 1)

    assert len(suggestions) == 1

    suggestion = suggestions[0]

    assert suggestion.get_suggested_user_id() == 4
    assert suggestion.get_score() == 2
    assert suggestion.get_mutual_friends_count() == 2