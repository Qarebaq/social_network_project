import json
import os

from graph.exceptions.graph_exceptions import InvalidGraphDataException
from persistence.graph_repository import GraphRepository
from persistence.mapper import GraphMapper


class JsonGraphRepository(GraphRepository):
    """ JSON graph repository. This module implements graph persistence using JSON files. It is responsible for saving graph data to disk and loading graph data back into application objects. """

    def __init__(self, mapper=None):
        self.mapper = mapper or GraphMapper()

    def save(self, graph, file_path):
        data = self.mapper.graph_to_dict(graph)
        directory = os.path.dirname(os.path.abspath(file_path))
        os.makedirs(directory, exist_ok=True)
        with open(file_path, "w", encoding="utf-8") as file:
            json.dump(data, file, ensure_ascii=False, indent=2)

    def load(self, file_path):
        if not self.exists(file_path):
            raise InvalidGraphDataException(f"Graph file not found: {file_path}")
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                data = json.load(file)
        except json.JSONDecodeError as exc:
            raise InvalidGraphDataException(
                f"File '{file_path}' is not valid JSON."
            ) from exc
        except OSError as exc:
            raise InvalidGraphDataException(
                f"Could not read graph file '{file_path}': {exc}"
            ) from exc
        return self.mapper.dict_to_graph(data)

    def exists(self, file_path):
        return os.path.isfile(file_path)
