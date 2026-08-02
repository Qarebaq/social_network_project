from graph.domain.friendship import Friendship
from graph.domain.graph import Graph
from graph.domain.user import User
from graph.exceptions.graph_exceptions import GraphException, InvalidGraphDataException


class GraphMapper:

    def graph_to_dict(self, graph):
        if not isinstance(graph, Graph):
            raise InvalidGraphDataException("Expected a Graph instance.")
        return {
            "users": [self.user_to_dict(user) for user in graph.get_users()],
            "friendships": [
                self.friendship_to_dict(friendship)
                for friendship in graph.get_friendships()
            ],
        }

    def dict_to_graph(self, data):
        if not isinstance(data, dict):
            raise InvalidGraphDataException("Graph data must be a JSON object.")
        if set(data) != {"users", "friendships"}:
            raise InvalidGraphDataException(
                "Graph data must contain only 'users' and 'friendships'."
            )
        if not isinstance(data["users"], list) or not isinstance(
            data["friendships"], list
        ):
            raise InvalidGraphDataException(
                "'users' and 'friendships' must be JSON arrays."
            )

        graph = Graph()
        try:
            for user_data in data["users"]:
                user = self.dict_to_user(user_data)
                graph.add_user(user.get_id(), user.get_name())
            for friendship_data in data["friendships"]:
                friendship = self.dict_to_friendship(friendship_data)
                graph.add_friendship(
                    friendship.get_user1_id(),
                    friendship.get_user2_id(),
                    friendship.get_weight(),
                )
        except (GraphException, ValueError) as exc:
            raise InvalidGraphDataException(f"Invalid graph data: {exc}") from exc
        return graph

    def user_to_dict(self, user):
        if not isinstance(user, User):
            raise InvalidGraphDataException("Expected a User instance.")
        return {"id": user.get_id(), "name": user.get_name()}

    def friendship_to_dict(self, friendship):
        if not isinstance(friendship, Friendship):
            raise InvalidGraphDataException("Expected a Friendship instance.")
        return {
            "user1_id": friendship.get_user1_id(),
            "user2_id": friendship.get_user2_id(),
            "weight": friendship.get_weight(),
        }

    def dict_to_user(self, data):
        if not isinstance(data, dict) or set(data) != {"id", "name"}:
            raise InvalidGraphDataException(
                "Each user must contain exactly 'id' and 'name'."
            )
        if not isinstance(data["id"], str) or not data["id"].strip():
            raise InvalidGraphDataException("User 'id' must be a non-empty string.")
        if not isinstance(data["name"], str) or not data["name"].strip():
            raise InvalidGraphDataException(
                "User 'name' must be a non-empty string."
            )
        return User(data["id"], data["name"])

    def dict_to_friendship(self, data):
        required_fields = {"user1_id", "user2_id", "weight"}
        if not isinstance(data, dict) or set(data) != required_fields:
            raise InvalidGraphDataException(
                "Each friendship must contain exactly 'user1_id', "
                "'user2_id', and 'weight'."
            )
        for field in ("user1_id", "user2_id"):
            if not isinstance(data[field], str) or not data[field].strip():
                raise InvalidGraphDataException(
                    f"Friendship '{field}' must be a non-empty string."
                )
        weight = data["weight"]
        if isinstance(weight, bool) or not isinstance(weight, (int, float)):
            raise InvalidGraphDataException("Friendship 'weight' must be a number.")
        return Friendship(data["user1_id"], data["user2_id"], weight)
