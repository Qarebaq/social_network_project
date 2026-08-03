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
        # call TraversalService.is_connected
        return self.traversal_service.is_connected(self.graph, user1_id, user2_id)

    def get_shortest_path(self, source_user_id, target_user_id):
        # call ShortestPathService.find_shortest_path
        return self.shortest_path_service.find_shortest_path(self.graph, source_user_id, target_user_id)

    # Person C

    def get_components(self):
        # call ComponentService.get_components
        return self.component_service.get_components(self.graph)

    def get_largest_components(self):
        # call ComponentService.get_largest_components
        return self.component_service.get_largest_components(self.graph)
    
    def get_most_connected_users(self):
        # call StatisticsService.get_most_connected_users
        return self.statistics_service.get_most_connected_users(self.graph)

    def get_graph_statistics(self):
        # call StatisticsService.get_graph_info
        return self.statistics_service.get_graph_info(self.graph)

    # Person D

    def suggest_friends(self, user_id):
        # call RecommendationService.suggest_friends
        return self.recommendation_service.suggest_friends(self.graph, user_id)

    def get_distances_from_user(self, source_user_id):
        # call DistanceService.get_distances_from_user
        return self.distance_service.get_distances_from_user(self.graph, source_user_id)

    # Optional

    def get_key_people(self):
        # TODO: call AdvancedAnalysisService key people method
        pass

    def get_communities(self):
        # TODO: call AdvancedAnalysisService community detection method
        pass