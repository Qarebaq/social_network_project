class ComponentResult:
    """ Connected component result model. This module defines the result object for a connected component in the social network graph. It stores the members of a friendship group and provides access to component-related information. """
    def __init__(self, members):
        self.members = members

    def get_members(self):
        # TODO: return component members
        pass

    def get_size(self):
        # TODO: return number of members
        pass

    def contains(self, user_id):
        # TODO: check if user_id exists in this component
        pass