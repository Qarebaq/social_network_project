"""
Network statistics service.

This module provides operations for calculating general statistics about the
social network, including user count, friendship count, average degree, largest
component, and users with the most friends.
"""

from graph.results.network_statistics import NetworkStatistics
from graph.services.component_service import ComponentService


class StatisticsService:
    """
    Service for calculating overall network statistics.
    """

    def __init__(self):
        # TODO: initialize required services
        self.component_service = ComponentService()

    def get_total_users(self, graph):
        """
        Return the total number of users in the graph.
        """
        return graph.get_user_count()

    def get_total_friendships(self, graph):
        """
        Return the total number of friendships in the graph.
        """
        return graph.get_friendship_count()

    def get_average_degree(self, graph):
        """
        Calculate the average degree of users in the graph.

        Formula:
            average_degree = 2 * E / V
        """
        total_users = self.get_total_users(graph)
        if total_users == 0:
            return 0.0
        return (2 * self.get_total_friendships(graph)) / total_users

    def get_maximum_degree(self, graph):
        """
        Return the maximum degree among all users.
        """
        user_ids = self._get_user_ids(graph)
        if not user_ids:
            return 0
        return max(graph.get_degree(user_id) for user_id in user_ids)

    def get_most_connected_users(self, graph):
        """
        Return the user or users with the highest number of friends.
        """
        user_ids = self._get_user_ids(graph)
        if not user_ids:
            return []

        maximum_degree = self.get_maximum_degree(graph)
        return [
            user_id
            for user_id in user_ids
            if graph.get_degree(user_id) == maximum_degree
        ]

    def get_largest_components(self, graph):
        """
        Return the largest connected component or components.
        """
        return self.component_service.get_largest_components(graph)

    def get_graph_info(self, graph):
        """
        Return a complete NetworkStatistics result object.
        """
        return NetworkStatistics(
            total_users=self.get_total_users(graph),
            total_friendships=self.get_total_friendships(graph),
            average_degree=self.get_average_degree(graph),
            largest_components=self.get_largest_components(graph),
            most_connected_users=self.get_most_connected_users(graph),
            maximum_degree=self.get_maximum_degree(graph)
        )

    def _get_user_ids(self, graph):
        """Normalize Graph.get_users() to a list of user identifiers."""
        users = graph.get_users()
        if isinstance(users, dict):
            return list(users.keys())

        user_ids = []
        for user in users:
            if hasattr(user, "get_id"):
                user_ids.append(user.get_id())
            elif hasattr(user, "user_id"):
                user_ids.append(user.user_id)
            else:
                user_ids.append(user)
        return user_ids
