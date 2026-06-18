class DistanceReport:
    def __init__(self, source_user_id, distances, unreachable_users):
        self.source_user_id = source_user_id
        self.distances = distances
        self.unreachable_users = unreachable_users

    def get_source_user_id(self):
        # TODO: return source user id
        pass

    def get_distances(self):
        # TODO: return distance map
        pass

    def get_distance_to(self, user_id):
        # TODO: return distance to specific user
        pass

    def get_unreachable_users(self):
        # TODO: return unreachable users
        pass

    def get_sorted_distances(self):
        # TODO: return distances sorted from minimum to maximum
        pass