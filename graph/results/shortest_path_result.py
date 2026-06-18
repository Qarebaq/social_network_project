class ShortestPathResult:
    def __init__(self, source_user_id, target_user_id, path, distance, exists):
        self.source_user_id = source_user_id
        self.target_user_id = target_user_id
        self.path = path
        self.distance = distance
        self.exists = exists

    def get_source_user_id(self):
        # TODO: return source user id
        pass

    def get_target_user_id(self):
        # TODO: return target user id
        pass

    def get_path(self):
        # TODO: return shortest path
        pass

    def get_distance(self):
        # TODO: return path distance
        pass

    def path_exists(self):
        # TODO: return whether path exists
        pass