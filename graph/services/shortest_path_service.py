from graph.results.shortest_path_result import ShortestPathResult
class ShortestPathService:
    def find_shortest_path(self, graph, source_user_id, target_user_id):
        # TODO: find shortest path using BFS
        pass

    def has_path(self, graph, source_user_id, target_user_id):
        # TODO: check whether a path exists between source and target
        pass

    def get_distance_between(self, graph, source_user_id, target_user_id):
        # TODO: return shortest distance between two users
        pass

    def _reconstruct_path(self, parent_map, source_user_id, target_user_id):
        # TODO: rebuild path from parent map
        pass

    def _validate_users(self, graph, source_user_id, target_user_id):
        # TODO: validate both users exist
        pass