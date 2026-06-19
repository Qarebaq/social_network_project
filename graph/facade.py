from graph.services.traversal_service import TraversalService
from graph.services.shortest_path_service import ShortestPathService
from graph.services.component_service import ComponentService
from graph.services.recommendation_service import RecommendationService
from graph.services.distance_service import DistanceService
from graph.services.statistics_service import StatisticsService
from graph.services.advanced_analysis_service import AdvancedAnalysisService


class GraphFacade:
    """ Graph facade. This module provides a simplified interface between the controller and the graph services. It delegates requests to the appropriate service classes while hiding the internal structure of the graph analysis layer. """
    def __init__(self, graph):
        self.graph = graph

        self.traversal_service = TraversalService()
        self.shortest_path_service = ShortestPathService()
        self.component_service = ComponentService()
        self.recommendation_service = RecommendationService()
        self.distance_service = DistanceService()
        self.statistics_service = StatisticsService()
        self.advanced_analysis_service = AdvancedAnalysisService()

    # Person B

    def is_connected(self, user1_id, user2_id):
        # TODO: call TraversalService.is_connected
        pass

    def get_shortest_path(self, source_user_id, target_user_id):
        # TODO: call ShortestPathService.find_shortest_path
        pass

    # Person C

    def get_components(self):
        # TODO: call ComponentService.get_components
        pass

    def get_largest_components(self):
        # TODO: call ComponentService.get_largest_components
        pass

    def get_most_connected_users(self):
        # TODO: call StatisticsService.get_most_connected_users
        pass

    def get_graph_statistics(self):
        # TODO: call StatisticsService.get_graph_info
        pass

    # Person D

    def suggest_friends(self, user_id):
        # TODO: call RecommendationService.suggest_friends
        pass

    def get_distances_from_user(self, source_user_id):
        # TODO: call DistanceService.get_distances_from_user
        pass

    # Optional

    def get_key_people(self):
        # TODO: call AdvancedAnalysisService key people method
        pass

    def get_communities(self):
        # TODO: call AdvancedAnalysisService community detection method
        pass