from collections import deque

from graph.results.shortest_path_result import ShortestPathResult


class ShortestPathService:
    """
    Shortest path service.

    This module provides operations for finding the shortest path
    between two users in an unweighted social network graph using BFS.
    """

    def find_shortest_path(self, graph, source_user_id, target_user_id):
        self._validate_users(graph, source_user_id, target_user_id)

        if source_user_id == target_user_id:
            return ShortestPathResult(
                [graph.get_user(source_user_id)],
                0
            )

        queue = deque([source_user_id])
        visited = {source_user_id}
        parent_map = {source_user_id: None}

        while queue:
            current = queue.popleft()

            for neighbor in graph.get_neighbors(current):
                if neighbor in visited:
                    continue

                visited.add(neighbor)
                parent_map[neighbor] = current

                if neighbor == target_user_id:
                    path = self._reconstruct_path(
                        parent_map,
                        source_user_id,
                        target_user_id,
                    )

                    return ShortestPathResult(
                        [graph.get_user(uid) for uid in path],
                        len(path) - 1,
                    )

                queue.append(neighbor)

        return ShortestPathResult([], -1)

    def has_path(self, graph, source_user_id, target_user_id):
        return self.get_distance_between(
            graph,
            source_user_id,
            target_user_id,
        ) != -1

    def get_distance_between(self, graph, source_user_id, target_user_id):
        self._validate_users(graph, source_user_id, target_user_id)

        if source_user_id == target_user_id:
            return 0

        queue = deque([(source_user_id, 0)])
        visited = {source_user_id}

        while queue:
            current, distance = queue.popleft()

            for neighbor in graph.get_neighbors(current):
                if neighbor in visited:
                    continue

                if neighbor == target_user_id:
                    return distance + 1

                visited.add(neighbor)
                queue.append((neighbor, distance + 1))

        return -1

    def _reconstruct_path(self, parent_map, source_user_id, target_user_id):
        path = []
        current = target_user_id

        while current is not None:
            path.append(current)
            current = parent_map[current]

        path.reverse()

        if not path or path[0] != source_user_id:
            return []

        return path

    def _validate_users(self, graph, source_user_id, target_user_id):
        if not graph.has_user(source_user_id):
            raise ValueError(f"User '{source_user_id}' does not exist.")

        if not graph.has_user(target_user_id):
            raise ValueError(f"User '{target_user_id}' does not exist.")