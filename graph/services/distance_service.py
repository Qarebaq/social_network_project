from graph.results.distance_report import DistanceReport


class DistanceService:

    def get_distances_from_user(self, graph, source_user_id):
        # TODO: calculate distance from source user to all users
        pass

    def get_sorted_distances_from_user(self, graph, source_user_id):
        # TODO: return distances sorted from minimum to maximum
        pass

    def get_unreachable_users(self, graph, source_user_id):
        # TODO: return users that are not reachable from source user
        pass

    def _bfs_distances(self, graph, source_user_id):
        # TODO: BFS and calculate distance map
        pass

    def _validate_source_user(self, graph, source_user_id):
        # TODO: validate that source user exists
        pass