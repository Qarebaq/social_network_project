from graph.domain.user import User
from graph.domain.friendship import Friendship
from graph.exceptions.graph_exceptions import (
    DuplicateFriendshipException,
    DuplicateUserException,
    FriendshipNotFoundException,
    SelfFriendshipException,
    UserNotFoundException,
)


class Graph:
    """ Graph domain model. This module contains the main Graph class responsible for storing users, friendships, and adjacency information. It provides core operations for adding, removing, updating, and querying users and friendships. """
    def __init__(self):
        self.users = {}
        self.adjacency_list = {}
        self.friendship_count = 0

    def add_user(self, user_id, name):
        # TODO: add new user
        if self.has_user(user_id):
            raise DuplicateUserException(f"User {user_id!r} already exists")
        user = User(user_id, name)
        if not user.is_valid():
            raise ValueError("User id and name must be non-empty")
        self.users[user_id] = user
        self.adjacency_list[user_id] = []
        return user

    def remove_user(self, user_id):
        # TODO: remove user and all related friendships
        self.validate_user_exists(user_id)
        for friendship in list(self.adjacency_list[user_id]):
            self.remove_friendship(user_id, friendship.get_other_user(user_id))
        del self.adjacency_list[user_id]
        return self.users.pop(user_id)

    def update_user(self, user_id, new_name):
        # TODO: update user name
        user = self.get_user(user_id)
        if not isinstance(new_name, str) or not new_name.strip():
            raise ValueError("User name must be non-empty")
        user.rename(new_name)
        return user

    def get_user(self, user_id):
        # TODO: return User object
        self.validate_user_exists(user_id)
        return self.users[user_id]

    def has_user(self, user_id):
        # TODO: check user existence
        return user_id in self.users

    def get_users(self):
        # TODO: return all user ids or User objects
        return list(self.users.values())

    def get_user_count(self):
        # TODO: return number of users
        return len(self.users)

    def add_friendship(self, user1_id, user2_id, weight=1):
        # TODO: add undirected friendship
        self.validate_friendship_allowed(user1_id, user2_id)
        friendship = Friendship(user1_id, user2_id, weight)
        self.adjacency_list[user1_id].append(friendship)
        self.adjacency_list[user2_id].append(friendship)
        self.friendship_count += 1
        return friendship

    def remove_friendship(self, user1_id, user2_id):
        # TODO: remove friendship
        self.validate_user_exists(user1_id)
        self.validate_user_exists(user2_id)
        friendship = next((item for item in self.adjacency_list[user1_id] if item.connects(user1_id, user2_id)), None)
        if friendship is None:
            raise FriendshipNotFoundException(f"Friendship between {user1_id!r} and {user2_id!r} does not exist")
        self.adjacency_list[user1_id].remove(friendship)
        self.adjacency_list[user2_id].remove(friendship)
        self.friendship_count -= 1
        return friendship

    def has_friendship(self, user1_id, user2_id):
        # TODO: check friendship existence
        if not self.has_user(user1_id) or not self.has_user(user2_id):
            return False
        return any(item.connects(user1_id, user2_id) for item in self.adjacency_list[user1_id])

    def get_friends(self, user_id):
        #adjacency_list assumed : {"1": {"2", "3"}}
        self.validate_user_exists(user_id)

        friends = []

        for friendship in self.adjacency_list[user_id]:
            friend_id = friendship.get_other_user(user_id)
            friends.append(self.users[friend_id])

        return friends

    def get_neighbors(self, user_id):
        """Return adjacent user identifiers for graph algorithms."""
        self.validate_user_exists(user_id)
        return [friendship.get_other_user(user_id) for friendship in self.adjacency_list[user_id]]

    def get_friendships(self):
        # TODO: return all friendships
        seen = set()
        friendships = []
        for adjacency in self.adjacency_list.values():
            for friendship in adjacency:
                key = friendship.normalized_key()
                if key not in seen:
                    seen.add(key)
                    friendships.append(friendship)
        return friendships

    def get_friendship_count(self):
        # TODO: return number of friendships
        return self.friendship_count

    def get_degree(self, user_id):
        # TODO: return degree of user
        self.validate_user_exists(user_id)
        return len(self.adjacency_list[user_id])

    def clear(self):
        # TODO: clear graph
        self.users.clear()
        self.adjacency_list.clear()
        self.friendship_count = 0

    def is_empty(self):
        # TODO: check if graph is empty
        return not self.users

    def validate_user_exists(self, user_id):
        # TODO: raise exception if user does not exist
        if not self.has_user(user_id):
            raise UserNotFoundException(f"User {user_id!r} does not exist")

    def validate_friendship_allowed(self, user1_id, user2_id):
        # TODO: validate friendship rules
        self.validate_user_exists(user1_id)
        self.validate_user_exists(user2_id)
        if user1_id == user2_id:
            raise SelfFriendshipException("A user cannot be friends with themselves")
        if self.has_friendship(user1_id, user2_id):
            raise DuplicateFriendshipException(f"Friendship between {user1_id!r} and {user2_id!r} already exists")
