from graph.domain.graph import Graph
from graph.services.recommendation_service import RecommendationService


def test_mutual_friends_are_unique_and_sorted():
    graph = Graph()
    for user_id in ("A", "B", "C", "D"):
        graph.add_user(user_id, user_id)
    for edge in (("A", "D"), ("B", "D"), ("A", "C"), ("B", "C")):
        graph.add_friendship(*edge)
    result = RecommendationService().get_mutual_friends(graph, "A", "B")
    assert [user.get_id() for user in result] == ["C", "D"]


def test_no_mutual_friends():
    graph = Graph()
    graph.add_user("A", "A")
    graph.add_user("B", "B")
    assert RecommendationService().get_mutual_friends(graph, "A", "B") == []


def test_exactly_one_mutual_friend():
    graph = Graph()
    for user_id in ("A", "B", "C"):
        graph.add_user(user_id, user_id)
    graph.add_friendship("A", "C")
    graph.add_friendship("B", "C")

    result = RecommendationService().get_mutual_friends(graph, "A", "B")

    assert [user.get_id() for user in result] == ["C"]
