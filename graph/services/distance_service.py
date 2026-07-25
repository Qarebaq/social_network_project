from collections import deque

from graph.results.distance_report import DistanceReport


class DistanceService:
    """ Distance analysis service. This module provides operations for calculating the distance from one user to all other users in the network. For the unweighted graph used in this project, distances are calculated with Breadth-First Search. """

    def get_distances_from_user(self, graph, source_user_id):

        self._validate_source_user(graph, source_user_id)

        distances = self._bfs_distances(graph, source_user_id)
        unreachable_users = self.get_unreachable_users(graph, source_user_id)

        return DistanceReport(
            source_user_id,
            distances,
            unreachable_users
        )

    def get_sorted_distances_from_user(self, graph, source_user_id):

        distances = self._bfs_distances(graph, source_user_id)

        return sorted(
            distances.items(),
            key=lambda item: item[1]
        )

    def get_unreachable_users(self, graph, source_user_id):

        distances = self._bfs_distances(graph, source_user_id)

        unreachable = []

        for user in graph.get_users():

            if user not in distances:
                unreachable.append(user)

        return unreachable

    def _bfs_distances(self, graph, source_user_id):

        visited = set()
        queue = deque()
        distances = {}

        visited.add(source_user_id)
        queue.append(source_user_id)
        distances[source_user_id] = 0

        while queue:

            current = queue.popleft()

            friends = graph.get_friends(current)

            for friend in friends:

                if friend not in visited:

                    visited.add(friend)
                    queue.append(friend)
                    distances[friend] = distances[current] + 1

        return distances

    def _validate_source_user(self, graph, source_user_id):

        if not graph.has_user(source_user_id):
            raise ValueError(f"User {source_user_id} does not exist.")
