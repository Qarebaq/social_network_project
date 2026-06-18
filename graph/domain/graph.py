from graph.domain.user import User
from graph.domain.friendship import Friendship


class Graph:

    def __init__(self):
        self.users = {}
        self.adjacency_list = {}
        self.friendship_count = 0

    def add_user(self, user_id, name):
        # TODO: add new user
        pass

    def remove_user(self, user_id):
        # TODO: remove user and all related friendships
        pass

    def update_user(self, user_id, new_name):
        # TODO: update user name
        pass

    def get_user(self, user_id):
        # TODO: return User object
        pass

    def has_user(self, user_id):
        # TODO: check user existence
        pass

    def get_users(self):
        # TODO: return all user ids or User objects
        pass

    def get_user_count(self):
        # TODO: return number of users
        pass

    def add_friendship(self, user1_id, user2_id, weight=1):
        # TODO: add undirected friendship
        pass

    def remove_friendship(self, user1_id, user2_id):
        # TODO: remove friendship
        pass

    def has_friendship(self, user1_id, user2_id):
        # TODO: check friendship existence
        pass

    def get_friends(self, user_id):
        # TODO: return friends of user
        pass

    def get_neighbors(self, user_id):
        # TODO: return neighbor ids
        pass

    def get_friendships(self):
        # TODO: return all friendships
        pass

    def get_friendship_count(self):
        # TODO: return number of friendships
        pass

    def get_degree(self, user_id):
        # TODO: return degree of user
        pass

    def clear(self):
        # TODO: clear graph
        pass

    def is_empty(self):
        # TODO: check if graph is empty
        pass

    def validate_user_exists(self, user_id):
        # TODO: raise exception if user does not exist
        pass

    def validate_friendship_allowed(self, user1_id, user2_id):
        # TODO: validate friendship rules
        pass