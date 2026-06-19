from graph.results.friend_suggestion_result import FriendSuggestionResult


class RecommendationService:
    """ Friend recommendation service. This module provides operations for suggesting new friends to a user. Suggestions are based on graph relationships such as friends of friends and mutual friends. """
    def suggest_friends(self, graph, user_id):
        # TODO: suggest friends for a user
        pass

    def get_friends_of_friends(self, graph, user_id):
        # TODO: return friends of user's friends
        pass

    def get_mutual_friends(self, graph, user1_id, user2_id):
        # TODO: return mutual friends between two users
        pass

    def calculate_suggestion_score(self, graph, user_id, candidate_user_id):
        # TODO: calculate score based on mutual friends or other criteria
        pass

    def _remove_invalid_candidates(self, graph, user_id, candidates):
        # TODO: remove self and existing friends from candidates
        pass