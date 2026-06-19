import sys

from PySide6.QtWidgets import QApplication

from graph.domain.graph import Graph
from graph.facade import GraphFacade
from persistence.json_graph_repository import JsonGraphRepository

from controllers.main_controller import MainController
from views.main_window import MainWindow


def main():

    """ Application entry point for the Social Network Analysis project. This module initializes the Qt application, creates the main project objects such as the graph, facade, repository, controller, and main window, then starts the application event loop. """

    # TODO: create QApplication
    app = QApplication(sys.argv)

    # TODO: create core objects
    graph = Graph()
    facade = GraphFacade(graph)
    repository = JsonGraphRepository()

    # TODO: create main window and controller
    main_window = MainWindow()
    controller = MainController(
        graph=graph,
        facade=facade,
        repository=repository,
        main_window=main_window
    )

    # TODO: connect controller to view if needed
    main_window.set_controller(controller)

    # TODO: show main window
    main_window.show()

    # TODO: start Qt event loop
    sys.exit(app.exec())


if __name__ == "__main__":
    main()