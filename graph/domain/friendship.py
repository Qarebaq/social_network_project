class Friendship:

    def __init__(self, user1_id, user2_id, weight=1):
        self.user1_id = user1_id
        self.user2_id = user2_id
        self.weight = weight

    def get_user1_id(self):
        # TODO: return first user id
        pass

    def get_user2_id(self):
        # TODO: return second user id
        pass

    def get_weight(self):
        # TODO: return friendship weight
        pass

    def contains_user(self, user_id):
        # TODO: check if user is part of friendship
        pass

    def get_other_user(self, user_id):
        # TODO: return the other user id
        pass

    def connects(self, user1_id, user2_id):
        # TODO: check if friendship connects two users
        pass

    def normalized_key(self):
        # TODO: return sorted tuple for undirected friendship
        pass

    def __eq__(self, other):
        # TODO: compare friendships as undirected edges
        pass

    def __hash__(self):
        # TODO: hash friendship by normalized key
        pass

    def __str__(self):
        # TODO: return readable friendship info
        pass