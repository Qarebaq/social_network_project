# Social Network Analysis Project

A data-structures project that models a social network as an undirected graph
and provides a Qt/QML interface for exploring it.

## Features

- Add and remove users
- Add and remove friendships
- Check connectivity and find shortest paths
- Find connected components and the largest friendship group
- Suggest friends and calculate distances from a user
- Calculate network statistics
- Save and load graphs as JSON

## Architecture

![Social Network UML](social_network_uml.png)

The project is separated into layers:

- **Domain**: `User`, `Friendship`, and the adjacency-list `Graph`
- **Services**: traversal, paths, components, recommendations, distances, and statistics
- **Results**: structured result objects returned by analysis services
- **Persistence**: JSON graph storage
- **Facade / Controller / Views**: application coordination and the Qt/QML interface

## Installation and execution

Python 3.10 or newer is recommended.

```bash
python -m venv .venv
```

Activate the environment, then install the dependencies:

```bash
python -m pip install -r requirements.txt
python main.py
```

Saved graphs are stored in the repository's `data/` directory.

## Tests

Run the complete suite from the repository root:

```bash
python -m pytest -q
```

Run the connected-components and statistics tests only:

```bash
python -m pytest tests/test_components.py tests/test_statistics.py -v
```

## Data structures and algorithms

The graph uses an adjacency list. For `V` users and `E` friendships, its
storage complexity is `O(V + E)`.

### Traversal and shortest paths

`TraversalService` implements breadth-first search (BFS) operations used for
core graph traversal.

It provides:

- listing a user's friends
- checking whether two users are connected
- finding mutual friends
- computing the shortest path between two users

Because the network is modeled as an unweighted graph, BFS guarantees the
minimum-hop path between two users.

Complexities:

- Friend listing: `O(deg(v))`
- Connectivity: `O(V + E)`
- Shortest path: `O(V + E)`
- Mutual friends: `O(deg(u) + deg(v))`

### Friend recommendation

`RecommendationService` suggests new friends by examining second-degree
connections (friends of friends).

Existing friends and the user themself are excluded from the candidate list.
Candidates are ranked by the number of mutual friends, so users with more shared
connections appear first.

Complexity:

- Time: `O(V + E)`
- Auxiliary space: `O(V)`

### Distance analysis

`DistanceService` performs a breadth-first search from a selected user and
computes the minimum distance to every reachable user.

Users that cannot be reached are reported separately with infinite distance.
Reachable users are sorted by increasing distance before presentation.

Complexities:

- BFS traversal: `O(V + E)`
- Sorting reachable users: `O(V log V)`

### Connected components

`ComponentService` scans every user and starts an iterative depth-first search
(DFS) whenever it finds an unvisited user. Each DFS returns one connected
component. Isolated users form components of size one, and an empty graph has no
components.

Across the complete scan, each user is visited once and each undirected
friendship is inspected from both endpoints:

- Time: `O(V + E)`
- Auxiliary space: `O(V)` for the visited set, DFS stack, and results

Finding the largest component first computes all components and then compares
their sizes, so its overall complexity remains `O(V + E)`. If several
components have the same maximum size, all of them are returned.

### Network statistics

`StatisticsService` reports:

- total users `V`
- total friendships `E`
- average degree `2E / V` (or `0.0` for an empty graph)
- maximum degree
- every user tied for maximum degree
- every connected component tied for largest size

User and friendship counts are `O(1)`. Average degree is also `O(1)`.
Maximum-degree and most-connected-user queries scan users and their stored
degrees, while the complete report is dominated by connected-component
discovery and therefore runs in `O(V + E)`.

## Qarebaq contribution

Qarebaq owns connected-component analysis and network statistics. The related
implementation and tests are primarily located in:

- `graph/services/component_service.py`
- `graph/services/statistics_service.py`
- `tests/test_components.py`
- `tests/test_statistics.py`

The tests cover empty graphs, isolated users, cycles, multiple and tied largest
components, unknown users, degree ties, complete statistics results, and facade
integration.

## Azarbad contribution

Azarbad implemented the application infrastructure, JSON persistence, and the
Qt/QML graphical interface.

The primary implementation is located in:

- `controllers/`
- `persistence/`
- `views/qml/`
- `main.py`

## Ghamiloui contribution

Ghamiloui implemented graph traversal and path-related algorithms, including
friend listing, connectivity checking, shortest paths, and mutual-friend
queries.

The related implementation is primarily located in:

- `graph/services/traversal_service.py`
- `graph/services/shortest_path_service.py`
- `tests/test_traversal.py`
- `tests/test_shortest_path.py`
- `tests/test_mutual_friends.py`

## Salehian contribution

Salehian implemented the friend-recommendation and distance-analysis modules.

The related implementation and tests are primarily located in:

- `graph/services/recommendation_service.py`
- `graph/services/distance_service.py`
- `tests/test_recommendation.py`
- `tests/test_distance.py`

The implementation uses breadth-first search (BFS) for distance computation and
friend-of-friend analysis for recommendation generation.