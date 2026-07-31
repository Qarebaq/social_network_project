from graph.results.friend_suggestion_result import FriendSuggestionResult


class RecommendationService:
    """Friend recommendation service."""

    def suggest_friends(self, graph, user_id):

        graph.validate_user_exists(user_id)

        candidates = self.get_friends_of_friends(graph, user_id)
        candidates = self._remove_invalid_candidates(
            graph,
            user_id,
            candidates
        )

        results = []

        for candidate in candidates:
            mutual_friends = self.get_mutual_friends(
                graph,
                user_id,
                candidate
            )

            score = len(mutual_friends)

            results.append(
                FriendSuggestionResult(
                    suggested_user_id=candidate,
                    mutual_friends=mutual_friends,
                    score=score
                )
            )

        results.sort(
            key=lambda item: (
                -item.get_score(),
                item.get_suggested_user_id()
            )
        )

        return results


    def get_friends_of_friends(self, graph, user_id):

        candidates = set()

        friends = graph.get_neighbors(user_id)

        for friend in friends:
            candidates.update(
                graph.get_neighbors(friend)
            )

        return candidates


    def get_mutual_friends(self, graph, user1_id, user2_id):

        friends1 = set(graph.get_neighbors(user1_id))
        friends2 = set(graph.get_neighbors(user2_id))

        return list(friends1 & friends2)


    def calculate_suggestion_score(
            self,
            graph,
            user_id,
            candidate_user_id):

        return len(
            self.get_mutual_friends(
                graph,
                user_id,
                candidate_user_id
            )
        )


    def _remove_invalid_candidates(
            self,
            graph,
            user_id,
            candidates):

        candidates = set(candidates)

        candidates.discard(user_id)

        current_friends = set(
            graph.get_neighbors(user_id)
        )

        return candidates - current_friends