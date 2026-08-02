class Friendship:
    """ Friendship domain model. This module defines the Friendship entity, which represents an undirected edge between two users in the social network graph. Each friendship may optionally store a weight, although the main project treats friendships as unweighted. """
    def __init__(self, user1_id, user2_id, weight=1):
        self.user1_id = user1_id
        self.user2_id = user2_id
        self.weight = weight

    def get_user1_id(self):
        # TODO: return first user id
        return self.user1_id

    def get_user2_id(self):
        # TODO: return second user id
        return self.user2_id

    def get_weight(self):
        # TODO: return friendship weight
        return self.weight

    def contains_user(self, user_id):
        # TODO: check if user is part of friendship
        return user_id == self.user1_id or user_id == self.user2_id

    def get_other_user(self, user_id):
        # TODO: return the other user id
        if user_id == self.user1_id:
            return self.user2_id
        if user_id == self.user2_id:
            return self.user1_id
        raise ValueError(f"User {user_id!r} is not part of this friendship")

    def connects(self, user1_id, user2_id):
        # TODO: check if friendship connects two users
        return self.normalized_key() == frozenset((user1_id, user2_id))

    def normalized_key(self):
        # TODO: return sorted tuple for undirected friendship
        return frozenset((self.user1_id, self.user2_id))

    def __eq__(self, other):
        # TODO: compare friendships as undirected edges
        if not isinstance(other, Friendship):
            return NotImplemented
        return self.normalized_key() == other.normalized_key()

    def __hash__(self):
        # TODO: hash friendship by normalized key
        return hash(self.normalized_key())

    def __str__(self):
        # TODO: return readable friendship info
        return f"Friendship({self.user1_id!r}, {self.user2_id!r}, weight={self.weight!r})"
