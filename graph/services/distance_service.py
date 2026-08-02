from collections import deque

from graph.results.distance_report import DistanceReport


class DistanceService:
    """Distance analysis service using BFS."""

    def get_distances_from_user(self, graph, source_user_id):
        self._validate_source_user(graph, source_user_id)

        distances = self._bfs_distances(graph, source_user_id)
        unreachable_users = self._get_unreachable_users(graph, distances)

        return DistanceReport(
            source_user_id,
            distances,
            unreachable_users
        )

    def get_sorted_distances_from_user(self, graph, source_user_id):
        report = self.get_distances_from_user(graph, source_user_id)
        return report.get_sorted_distances()

    def _get_unreachable_users(self, graph, distances):
        return [
            user_id
            for user_id in graph.get_users()
            if user_id not in distances
        ]

    def _bfs_distances(self, graph, source_user_id):
        visited = {source_user_id}
        queue = deque([source_user_id])

        distances = {
            source_user_id: 0
        }

        while queue:
            current = queue.popleft()

            for neighbor in graph.get_neighbors(current):
                if neighbor in visited:
                    continue

                visited.add(neighbor)
                distances[neighbor] = distances[current] + 1
                queue.append(neighbor)

        return distances

    def _validate_source_user(self, graph, source_user_id):
        graph.validate_user_exists(source_user_id)