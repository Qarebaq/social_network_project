from collections import deque


class DistanceService:

    def __init__(self, graph):
        self.graph = graph

    def distances_from(self, user_id):

        visited = set()
        queue = deque()
        distances = {}

        visited.add(user_id)
        queue.append(user_id)
        distances[user_id] = 0

        while queue:

            current = queue.popleft()

            friends = self.graph.get_friends(current)

            for friend in friends:

                if friend not in visited:

                    visited.add(friend)
                    queue.append(friend)
                    distances[friend] = distances[current] + 1

        return distances
