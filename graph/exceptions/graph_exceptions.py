class GraphException(Exception):
    """
    Base exception for graph errors
    """
    pass


class UserNotFoundException(GraphException):
    # TODO: raised when user does not exist
    pass


class DuplicateUserException(GraphException):
    # TODO: raised when user id already exists
    pass


class FriendshipNotFoundException(GraphException):
    # TODO: raised when friendship does not exist
    pass


class DuplicateFriendshipException(GraphException):
    # TODO: raised when friendship already exists
    pass


class SelfFriendshipException(GraphException):
    # TODO: raised when user tries to be friend with themselves
    pass


class InvalidGraphDataException(GraphException):
    # TODO: raised when graph data is invalid
    pass