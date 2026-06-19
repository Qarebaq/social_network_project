from PySide6.QtWidgets import QMainWindow, QWidget, QVBoxLayout, QHBoxLayout

from views.graph_view import GraphView
from views.user_panel import UserPanel
from views.result_panel import ResultPanel


class MainWindow(QMainWindow):
    """ Main application window. This module defines the main Qt window of the application. It organizes the main UI panels, connects view-level signals, and provides methods for refreshing and displaying application data. """
    def __init__(self):
        super().__init__()

        self.controller = None

        # TODO: initialize UI
        self.graph_view = GraphView()
        self.user_panel = UserPanel()
        self.result_panel = ResultPanel()

        self._setup_window()
        self._setup_layout()
        self._connect_signals()

    def set_controller(self, controller):
        # TODO: set controller reference
        self.controller = controller

    def _setup_window(self):
        # TODO: set title, size, and basic window settings
        pass

    def _setup_layout(self):
        # TODO: create main layout and add graph/user/result panels
        pass

    def _connect_signals(self):
        # TODO: connect child widgets signals to controller methods
        pass

    def refresh_graph(self, graph):
        # TODO: update graph view
        pass

    def refresh_users(self, users):
        # TODO: update user panel
        pass

    def show_result(self, title, content):
        # TODO: show result in result panel
        pass

    def show_error(self, message):
        # TODO: show error dialog/message
        pass
