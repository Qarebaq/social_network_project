from controllers.main_controller import MainController
from graph.domain.graph import Graph
from graph.facade import GraphFacade


class FakeMainWindow:
    """Minimal stand-in for QmlBridge, recording every call the
    controller makes so tests can assert on it without Qt."""

    def __init__(self):
        self.users_refreshed = None
        self.graph_refreshed = None
        self.results = []
        self.errors = []
        self.highlighted_paths = []

    def refresh_users(self, users):
        self.users_refreshed = list(users)

    def refresh_graph(self, graph):
        self.graph_refreshed = graph

    def show_result(self, title, content):
        self.results.append((title, content))

    def show_error(self, message):
        self.errors.append(message)

    def highlight_path(self, user_ids):
        self.highlighted_paths.append(list(user_ids))


def build_controller():
    graph = Graph()
    graph.add_user("A", "Alice")
    graph.add_user("B", "Bob")
    facade = GraphFacade(graph)
    window = FakeMainWindow()
    controller = MainController(graph=graph, facade=facade, repository=None, main_window=window)
    return controller, graph, window


def test_handle_update_user_renames_user_and_refreshes_views():
    controller, graph, window = build_controller()

    controller.handle_update_user("A", "Alicia")

    assert graph.get_user("A").get_name() == "Alicia"
    # refresh_all_views() must touch both the user list and the graph view
    assert window.graph_refreshed is graph
    assert [u.get_id() for u in window.users_refreshed] == ["A", "B"]
    assert not window.errors


def test_handle_update_user_missing_user_reports_error_without_raising():
    controller, _graph, window = build_controller()

    controller.handle_update_user("missing", "New Name")

    assert len(window.errors) == 1
    assert isinstance(window.errors[0], str)
    assert not window.results


def test_handle_update_user_rejects_empty_name():
    controller, graph, window = build_controller()

    controller.handle_update_user("A", "   ")

    assert graph.get_user("A").get_name() == "Alice"
    assert len(window.errors) == 1


def test_handle_check_connection_highlights_shortest_path_when_connected():
    controller, graph, window = build_controller()
    graph.add_friendship("A", "B")

    controller.handle_check_connection("A", "B")

    assert window.highlighted_paths[-1] == ["A", "B"]


def test_handle_check_connection_clears_highlight_when_not_connected():
    controller, _graph, window = build_controller()

    controller.handle_check_connection("A", "B")

    assert window.highlighted_paths[-1] == []