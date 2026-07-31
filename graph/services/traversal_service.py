from collections import deque


class TraversalService:
    """
    Graph traversal service.

    This module contains traversal-related operations such as BFS,
    DFS, reachability checks, and connected-user discovery.
    """

    def bfs(self, graph, start_user_id):
        self._validate_start_user(graph, start_user_id)

        visited = set()
        order = []
        queue = deque([start_user_id])

        while queue:
            current = queue.popleft()

            if current in visited:
                continue

            visited.add(current)
            order.append(graph.get_user(current))

            for neighbor in graph.get_neighbors(current):
                if neighbor not in visited:
                    queue.append(neighbor)

        return order

    def dfs(self, graph, start_user_id):
        self._validate_start_user(graph, start_user_id)

        visited = set()
        order = []
        stack = [start_user_id]

        while stack:
            current = stack.pop()

            if current in visited:
                continue

            visited.add(current)
            order.append(graph.get_user(current))

            # Reverse preserves a deterministic traversal order.
            neighbors = list(graph.get_neighbors(current))
            for neighbor in reversed(neighbors):
                if neighbor not in visited:
                    stack.append(neighbor)

        return order

    def is_connected(self, graph, user1_id, user2_id):
        self._validate_start_user(graph, user1_id)
        self._validate_start_user(graph, user2_id)

        if user1_id == user2_id:
            return True

        visited = {user1_id}
        queue = deque([user1_id])

        while queue:
            current = queue.popleft()

            for neighbor in graph.get_neighbors(current):
                if neighbor == user2_id:
                    return True

                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)

        return False

    def get_reachable_users(self, graph, start_user_id):
        return self.bfs(graph, start_user_id)

    def _validate_start_user(self, graph, user_id):
        if not graph.has_user(user_id):
            raise ValueError(f"User '{user_id}' does not exist.")