class GraphRepository:
    """ Graph repository interface. This module defines the common storage interface for saving and loading graph data. Concrete repository implementations should follow this contract. """

    def save(self, graph, file_path):
        # TODO: save graph to storage
        pass

    def load(self, file_path):
        # TODO: load graph from storage
        pass

    def exists(self, file_path):
        # TODO: check if storage file exists
        pass