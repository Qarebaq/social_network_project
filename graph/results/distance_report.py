class DistanceReport:
    """Distance report result model."""
    def __init__(self, source_user_id, distances, unreachable_users):
        self.source_user_id = source_user_id
        self.distances = distances
        self.unreachable_users = unreachable_users

    def get_source_user_id(self):
        return self.source_user_id

    def get_distances(self):
        return self.distances

    def get_distance_to(self, user_id):
        return self.distances.get(user_id)

    def get_unreachable_users(self):
        return self.unreachable_users

    def get_sorted_distances(self):
        return sorted(
            self.distances.items(),
            key=lambda item: item[1]
        )