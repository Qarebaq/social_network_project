from graph.services.component_service import ComponentService
from graph.services.statistics_service import StatisticsService


class GraphFacade:
    def __init__(self, graph):
        self.graph = graph

        # TODO: other services from other teammates
        self.component_service = ComponentService()
        self.statistics_service = StatisticsService()

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