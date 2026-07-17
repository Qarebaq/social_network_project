class NetworkStatistics:
    """ Network statistics result model. This module defines the result object returned by network statistics operations. It stores summary information such as total users, total friendships, average degree, largest components, and most connected users. """
    def __init__(
        self,
        total_users,
        total_friendships,
        average_degree,
        largest_components,
        most_connected_users,
        maximum_degree
    ):
        self.total_users = total_users
        self.total_friendships = total_friendships
        self.average_degree = average_degree
        self.largest_components = largest_components
        self.most_connected_users = most_connected_users
        self.maximum_degree = maximum_degree

    def get_total_users(self):
        # return total users count
        return self.total_users

    def get_total_friendships(self):
        # return total friendships count
        return self.total_friendships

    def get_average_degree(self):
        # return average degree
        return self.average_degree

    def get_largest_components(self):
        # return largest connected components
        return list(self.largest_components)


    def get_most_connected_users(self):
        # return users with maximum degree
        return list(self.most_connected_users)


    def get_maximum_degree(self):
        # return maximum degree
        return self.maximum_degree