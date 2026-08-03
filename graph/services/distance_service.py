from collections import deque

from graph.results.distance_report import DistanceReport


class DistanceService:
    """ Distance analysis service. This module provides operations for calculating the distance from one user to all other users in the network. For the unweighted graph used in this project, distances are calculated with Breadth-First Search. """

    def get_distances_from_user(self, graph, source_user_id):
        self._validate_source_user(graph, source_user_id)

        distances = self._bfs_distances(graph, source_user_id)
        distances.pop(source_user_id, None)

        unreachable_users = [
            user.get_id()
            for user in graph.get_users()
            if user.get_id() != source_user_id and user.get_id() not in distances
        ]

        return DistanceReport(source_user_id, distances, unreachable_users)

    def get_sorted_distances_from_user(self, graph, source_user_id):
        report = self.get_distances_from_user(graph, source_user_id)
        return report.get_sorted_distances()

    def get_unreachable_users(self, graph, source_user_id):
        report = self.get_distances_from_user(graph, source_user_id)
        return report.get_unreachable_users()

    def _bfs_distances(self, graph, source_user_id):
        distances = {source_user_id: 0}
        queue = deque([source_user_id])

        while queue:
            current = queue.popleft()
            for neighbor_id in graph.get_neighbors(current):
                if neighbor_id not in distances:
                    distances[neighbor_id] = distances[current] + 1
                    queue.append(neighbor_id)

        return distances

    def _validate_source_user(self, graph, source_user_id):
        graph.validate_user_exists(source_user_id)