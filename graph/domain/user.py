class User:
    """ User domain model. This module defines the User entity, which represents a single vertex in the social network graph. Each user has a unique identifier and a display name. """
    def __init__(self, user_id, name):
        self.user_id = user_id
        self.name = name

    def get_id(self):
        # TODO: return user id
        pass

    def get_name(self):
        # TODO: return user name
        pass

    def rename(self, new_name):
        # TODO: update user name
        pass

    def is_valid(self):
        # TODO: validate user data
        pass

    def __eq__(self, other):
        # TODO: compare users by id
        pass

    def __hash__(self):
        # TODO: hash user by id
        pass

    def __str__(self):
        # TODO: return readable user info
        pass