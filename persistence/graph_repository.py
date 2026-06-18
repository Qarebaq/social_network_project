class GraphRepository:
    """
    Interface for graph storage
    """

    def save(self, graph, file_path):
        # TODO: save graph to storage
        pass

    def load(self, file_path):
        # TODO: load graph from storage
        pass

    def exists(self, file_path):
        # TODO: check if storage file exists
        pass