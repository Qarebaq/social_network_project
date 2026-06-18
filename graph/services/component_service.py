from graph.results.component_result import ComponentResult


class ComponentService:
    def get_components(self, graph):
        # TODO: implement DFS/BFS to find all connected components
        pass

    def get_component_of_user(self, graph, user_id):
        # TODO: find connected component containing user_id
        pass

    def get_largest_components(self, graph):
        # TODO: find largest connected components
        pass

    def count_components(self, graph):
        # TODO: return number of connected components
        pass

    def _dfs(self, graph, start_user_id, visited):
        # TODO: implement DFS traversal for one component
        pass