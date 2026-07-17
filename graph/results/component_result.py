class ComponentResult:
    """ Connected component result model. This module defines the result object for a connected component in the social network graph. It stores the members of a friendship group and provides access to component-related information. """
    def __init__(self, members):
        self.members = list(members)
        
    def get_members(self):
        # return component members
        return list(self.members)

    def get_size(self):
        # return number of members
        return len(self.members)
    def contains(self, user_id):
        # check if user_id exists in this component
        return user_id in self.members