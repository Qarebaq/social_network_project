from graph.results.friend_suggestion_result import FriendSuggestionResult


class RecommendationService:
    """ Friend recommendation service. This module provides operations for suggesting new friends to a user. Suggestions are based on graph relationships such as friends of friends and mutual friends. """
    def suggest_friends(self, graph, user_id):
        graph.validate_user_exists(user_id)

        candidate_ids = self._remove_invalid_candidates(
            graph, user_id, self._collect_friends_of_friends_ids(graph, user_id)
        )

        suggestions = [
            FriendSuggestionResult(
                candidate_id,
                self.get_mutual_friends(graph, user_id, candidate_id),
                self.calculate_suggestion_score(graph, user_id, candidate_id),
            )
            for candidate_id in candidate_ids
        ]

        suggestions.sort(key=lambda s: s.get_score(), reverse=True)
        return suggestions

    def get_friends_of_friends(self, graph, user_id):
        graph.validate_user_exists(user_id)
        candidate_ids = self._remove_invalid_candidates(
            graph, user_id, self._collect_friends_of_friends_ids(graph, user_id)
        )
        return [graph.get_user(candidate_id) for candidate_id in candidate_ids]

    def get_mutual_friends(self, graph, user1_id, user2_id):
        graph.validate_user_exists(user1_id)
        graph.validate_user_exists(user2_id)

        mutual = set(graph.get_friends(user1_id)) & set(graph.get_friends(user2_id))

        return sorted(mutual, key=lambda user: user.get_id())
    
    def calculate_suggestion_score(self, graph, user_id, candidate_user_id):
        return len(self.get_mutual_friends(graph, user_id, candidate_user_id))

    def _remove_invalid_candidates(self, graph, user_id, candidates):
        existing_friend_ids = {friend.get_id() for friend in graph.get_friends(user_id)}
        return sorted(
            candidate_id
            for candidate_id in candidates
            if candidate_id != user_id and candidate_id not in existing_friend_ids
        )

    def _collect_friends_of_friends_ids(self, graph, user_id):
        candidate_ids = set()
        for friend_id in graph.get_neighbors(user_id):
            candidate_ids.update(graph.get_neighbors(friend_id))
        return candidate_ids