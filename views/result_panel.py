from PySide6.QtWidgets import QWidget


class ResultPanel(QWidget):

    def __init__(self):
        super().__init__()

        self._setup_ui()

    def _setup_ui(self):
        # TODO: create result title and result content widgets
        pass

    def show_text_result(self, title, text):
        # TODO: show plain text result
        pass

    def show_components(self, components):
        # TODO: show connected components
        pass

    def show_shortest_path(self, shortest_path_result):
        # TODO: show shortest path result
        pass

    def show_friend_suggestions(self, suggestions):
        # TODO: show friend suggestion results
        pass

    def show_distances(self, distance_report):
        # TODO: show distance report
        pass

    def show_statistics(self, network_statistics):
        # TODO: show graph statistics
        pass

    def clear(self):
        # TODO: clear result panel
        pass