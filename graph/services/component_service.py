from graph.results.component_result import ComponentResult


class ComponentService:
    """ Connected component service. This module provides operations for finding connected components in the social network graph. Components represent separate friendship groups inside the network. """
    def get_components(self, graph):
        visited = set()
        components = []

        for user_id in self._get_user_ids(graph):
            if user_id not in visited:
                members = self._dfs(graph, user_id, visited)
                components.append(ComponentResult(members))

        return components

    def get_component_of_user(self, graph, user_id):
        graph.validate_user_exists(user_id)
        members = self._dfs(graph, user_id, set())
        return ComponentResult(members)

    def get_largest_components(self, graph):
        components = self.get_components(graph)
        if not components:
            return []

        largest_size = max(component.get_size() for component in components)
        return [
            component
            for component in components
            if component.get_size() == largest_size
        ]

    def count_components(self, graph):
        return len(self.get_components(graph))

    def _dfs(self, graph, start_user_id, visited):
        members = []
        stack = [start_user_id]

        while stack:
            user_id = stack.pop()
            if user_id in visited:
                continue

            visited.add(user_id)
            members.append(user_id)

            neighbors = [
                neighbor_id
                for neighbor_id in graph.get_neighbors(user_id)
                if neighbor_id not in visited
            ]
            stack.extend(neighbors)

        return members

    def _get_user_ids(self, graph):
        """Normalize Graph.get_users() to a list of user identifiers."""
        users = graph.get_users()
        if isinstance(users, dict):
            return list(users.keys())

        user_ids = []
        for user in users:
            if hasattr(user, "get_id"):
                user_ids.append(user.get_id())
            elif hasattr(user, "user_id"):
                user_ids.append(user.user_id)
            else:
                user_ids.append(user)
        return user_ids
