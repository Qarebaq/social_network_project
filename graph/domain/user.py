class User:
    """ User domain model. This module defines the User entity, which represents a single vertex in the social network graph. Each user has a unique identifier and a display name. """
    def __init__(self, user_id, name):
        self.user_id = user_id
        self.name = name

    def get_id(self):
        return self.user_id

    def get_name(self):
        # TODO: return user name
        return self.name

    def rename(self, new_name):
        # TODO: update user name
        self.name = new_name

    def is_valid(self):
        # TODO: validate user data
        return self.user_id is not None and self.user_id != "" and isinstance(self.name, str) and bool(self.name.strip())

    def __eq__(self, other):
        # TODO: compare users by id
        if not isinstance(other, User):
            return NotImplemented
        return self.user_id == other.user_id

    def __hash__(self):
        # TODO: hash user by id
        return hash(self.user_id)

    def __str__(self):
        # TODO: return readable user info
        return f"User(id={self.user_id!r}, name={self.name!r})"
