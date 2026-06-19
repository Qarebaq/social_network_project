from PySide6.QtWidgets import QWidget


class GraphView(QWidget):


    def __init__(self):
        super().__init__()

        self.graph = None

        # TODO: initialize graph drawing area
        self._setup_ui()

    def _setup_ui(self):
        # TODO: setup graph visualization widget
        pass

    def set_graph(self, graph):
        # TODO: set graph data and redraw
        pass

    def refresh(self):
        # TODO: redraw graph
        pass

    def draw_users(self):
        # TODO: draw graph nodes
        pass

    def draw_friendships(self):
        # TODO: draw graph edges
        pass

    def highlight_path(self, path):
        # TODO: highlight shortest path
        pass

    def highlight_component(self, component):
        # TODO: highlight connected component
        pass

    def clear_highlights(self):
        # TODO: remove all highlights
        pass