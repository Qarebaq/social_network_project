import sys
from pathlib import Path

from PySide6.QtCore import QObject, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from graph.domain.graph import Graph
from graph.facade import GraphFacade
from persistence.json_graph_repository import JsonGraphRepository

from controllers.main_controller import MainController


class QmlBridge(QObject):
    """
    Takes the place of the old QWidget MainWindow. MainController calls
    set_controller / refresh_graph / refresh_users / show_result /
    show_error on whatever "main window" object it's given - this class
    implements that same interface but turns each call into a Qt signal
    that the QML UI listens to, and exposes slots QML can call back into
    the controller with.

    NOTE: refresh_graph/refresh_users assume graph.get_users(),
    user.get_id()/get_name(), graph.get_neighbors(user_id) exist, per
    the UML diagram. Adjust here if the real method names differ.
    """

    usersChanged = Signal(list)
    graphChanged = Signal(list, list)
    resultReady = Signal(str, str)
    errorOccurred = Signal(str)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._controller = None

    # ---- called by MainController ------------------------------------
    def set_controller(self, controller):
        self._controller = controller

    def refresh_graph(self, graph):
        nodes, edges = [], []
        try:
            seen = set()
            for user in graph.get_users():
                uid = user.get_id()
                nodes.append({"id": uid, "name": user.get_name()})
                for neighbor_id in graph.get_neighbors(uid):
                    key = tuple(sorted((str(uid), str(neighbor_id))))
                    if key not in seen:
                        seen.add(key)
                        edges.append({"source": uid, "target": neighbor_id})
        except Exception as exc:  # noqa: BLE001
            self.show_error(f"Could not read graph for display: {exc}")
            return
        self.graphChanged.emit(nodes, edges)

    def refresh_users(self, users):
        try:
            user_list = [{"id": u.get_id(), "name": u.get_name()} for u in users]
        except Exception as exc:  # noqa: BLE001
            self.show_error(f"Could not read user list: {exc}")
            return
        self.usersChanged.emit(user_list)

    def show_result(self, title, content):
        self.resultReady.emit(title, str(content))

    def show_error(self, message):
        self.errorOccurred.emit(str(message))

    # ---- called by QML -------------------------------------------------
    @Slot(str, str)
    def addUser(self, user_id, name):
        self._run(lambda: self._controller.handle_add_user(user_id, name))

    @Slot(str, str)
    def addFriendship(self, user1_id, user2_id):
        self._run(lambda: self._controller.handle_add_friendship(user1_id, user2_id))

    @Slot(str)
    def removeUser(self, user_id):
        self._run(lambda: self._controller.handle_remove_user(user_id))

    @Slot(str, str)
    def removeFriendship(self, user1_id, user2_id):
        self._run(lambda: self._controller.handle_remove_friendship(user1_id, user2_id))

    @Slot(str, str)
    def checkConnection(self, user1_id, user2_id):
        self._run(lambda: self._controller.handle_check_connection(user1_id, user2_id))

    @Slot(str, str)
    def findShortestPath(self, source_id, target_id):
        self._run(lambda: self._controller.handle_shortest_path(source_id, target_id))

    @Slot()
    def showComponents(self):
        self._run(lambda: self._controller.handle_show_components())

    @Slot()
    def showStatistics(self):
        self._run(lambda: self._controller.handle_show_graph_statistics())

    @Slot(str)
    def suggestFriends(self, user_id):
        self._run(lambda: self._controller.handle_suggest_friends(user_id))

    @Slot(str)
    def distancesFromUser(self, source_id):
        self._run(lambda: self._controller.handle_distances_from_user(source_id))

    @Slot(str)
    def saveGraph(self, file_path):
        self._run(lambda: self._controller.handle_save_graph(file_path))

    @Slot(str)
    def loadGraph(self, file_path):
        self._run(lambda: self._controller.handle_load_graph(file_path))

    def _run(self, action):
        if self._controller is None:
            self.show_error("Controller is not connected yet.")
            return
        try:
            action()
        except Exception as exc:  # noqa: BLE001
            self.show_error(str(exc))


def main():

    """ Application entry point for the Social Network Analysis project.
    Initializes the Qt/QML application, creates the core objects (graph,
    facade, repository, controller), connects them to the QML UI
    (views/qml/App.qml) through a QmlBridge, and starts the event loop. """

    app = QGuiApplication(sys.argv)

    graph = Graph()
    facade = GraphFacade(graph)
    repository = JsonGraphRepository()

    bridge = QmlBridge()
    controller = MainController(
        graph=graph,
        facade=facade,
        repository=repository,
        main_window=bridge,
    )
    bridge.set_controller(controller)
    controller.refresh_all_views()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("bridge", bridge)

    qml_entry_point = Path(__file__).resolve().parent / "views" / "qml" / "App.qml"
    engine.load(str(qml_entry_point))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()