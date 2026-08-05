from pathlib import Path

# Same fixed folder main.py points the QML file picker at - keeps every
# saved/loaded graph in one predictable place instead of scattered paths.
DATA_DIR = Path(__file__).resolve().parent.parent / "data"


class MainController:
    """ Main controller for the Social Network Analysis application. This module connects the graphical user interface to the graph logic. It handles user actions from the UI, calls the appropriate facade or repository methods, updates views, and manages application-level errors. """
    def __init__(self, graph, facade, repository, main_window):
        self.graph = graph
        self.facade = facade
        self.repository = repository
        self.main_window = main_window

    # -------------------------
    # User actions
    # -------------------------

    def handle_add_user(self, user_id, name):
        try:
            self.graph.add_user(user_id, name)
            self.refresh_all_views()
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_remove_user(self, user_id):
        try:
            self.graph.remove_user(user_id)
            self.refresh_all_views()
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_update_user(self, user_id, new_name):
        try:
            self.graph.update_user(user_id, new_name)
            self.refresh_all_views()
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    # -------------------------
    # Friendship actions
    # -------------------------

    def handle_add_friendship(self, user1_id, user2_id):
        try:
            self.graph.add_friendship(user1_id, user2_id)
            self.refresh_all_views()
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_remove_friendship(self, user1_id, user2_id):
        try:
            self.graph.remove_friendship(user1_id, user2_id)
            self.refresh_all_views()
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    # -------------------------
    # Person B actions
    # -------------------------

    def handle_check_connection(self, user1_id, user2_id):
        try:
            connected = self.facade.is_connected(user1_id, user2_id)
            status = "are connected" if connected else "are NOT connected"
            self.main_window.show_result(
                "Check Connection", f"{user1_id} and {user2_id} {status}."
            )
            if connected:
                result = self.facade.get_shortest_path(user1_id, user2_id)
                path_ids = [user.get_id() for user in result.get_path()]
                self.main_window.highlight_path(path_ids)
            else:
                self.main_window.highlight_path([])
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_shortest_path(self, source_user_id, target_user_id):
        try:
            result = self.facade.get_shortest_path(source_user_id, target_user_id)
            if result.path_exists():
                path_names = " -> ".join(user.get_name() for user in result.get_path())
                content = f"Distance: {result.get_distance()}\nPath: {path_names}"
            else:
                content = f"No path exists between {source_user_id} and {target_user_id}."
            self.main_window.show_result("Shortest Path", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    # -------------------------
    # Person C actions
    # -------------------------

    def handle_show_components(self):
        try:
            components = self.facade.get_components()
            if not components:
                content = "No users in the graph yet."
            else:
                content = "\n".join(
                    f"Component {i + 1} ({component.get_size()} users): "
                    + ", ".join(sorted(component.get_members()))
                    for i, component in enumerate(components)
                )
            self.main_window.show_result("Connected Components", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_show_largest_components(self):
        try:
            components = self.facade.get_largest_components()
            if not components:
                content = "No users in the graph yet."
            else:
                content = "\n".join(
                    f"Component {i + 1} ({component.get_size()} users): "
                    + ", ".join(sorted(component.get_members()))
                    for i, component in enumerate(components)
                )
            self.main_window.show_result("Largest Components", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_show_graph_statistics(self):
        try:
            stats = self.facade.get_graph_statistics()
            most_connected = ", ".join(stats.get_most_connected_users()) or "-"
            content = (
                f"Total users: {stats.get_total_users()}\n"
                f"Total friendships: {stats.get_total_friendships()}\n"
                f"Average degree: {stats.get_average_degree():.2f}\n"
                f"Maximum degree: {stats.get_maximum_degree()}\n"
                f"Most connected: {most_connected}\n"
                f"Largest components: {len(stats.get_largest_components())}"
            )
            self.main_window.show_result("Graph Statistics", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    # -------------------------
    # Person D actions
    # -------------------------

    def handle_suggest_friends(self, user_id):
        try:
            suggestions = self.facade.suggest_friends(user_id)
            if not suggestions:
                content = f"No friend suggestions available for {user_id}."
            else:
                content = "\n".join(
                    f"{s.get_suggested_user_id()} - "
                    f"{s.get_mutual_friends_count()} mutual friend(s) "
                    f"(score {s.get_score()})"
                    for s in suggestions
                )
            self.main_window.show_result("Suggested Friends", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_distances_from_user(self, source_user_id):
        try:
            report = self.facade.get_distances_from_user(source_user_id)
            lines = [f"{uid}: {dist}" for uid, dist in report.get_sorted_distances()]
            if report.get_unreachable_users():
                lines.append("Unreachable: " + ", ".join(report.get_unreachable_users()))
            content = "\n".join(lines) if lines else "No other users in the graph."
            self.main_window.show_result("Distances", content)
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    # -------------------------
    # Persistence actions
    # -------------------------

    def handle_save_graph(self, file_name):
        try:
            path = self._resolve_save_path(file_name)
            self.repository.save(self.graph, path)
            self.main_window.show_result("Save Graph", f"Graph saved to '{path}'.")
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def handle_load_graph(self, file_path):
        try:
            path = self._resolve_load_path(file_path)
            loaded_graph = self.repository.load(path)
            # Mutate the existing graph in place so the same instance
            # already shared with GraphFacade stays up to date.
            self.graph.clear()
            for user in loaded_graph.get_users():
                self.graph.add_user(user.get_id(), user.get_name())
            for friendship in loaded_graph.get_friendships():
                self.graph.add_friendship(
                    friendship.get_user1_id(),
                    friendship.get_user2_id(),
                    friendship.get_weight(),
                )
            self.refresh_all_views()
            self.main_window.show_result("Load Graph", f"Graph loaded from '{path}'.")
        except Exception as exc:  # noqa: BLE001
            self.handle_error(exc)

    def _resolve_save_path(self, file_name):
        """Always save inside DATA_DIR, always as .json, ignoring any
        directory the user may have typed in."""
        name = Path(str(file_name).strip()).name
        if not name:
            raise ValueError("File name must not be empty.")
        if not name.lower().endswith(".json"):
            name += ".json"
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        return str(DATA_DIR / name)

    def _resolve_load_path(self, file_path):
        """Accept a full path picked from the OS file dialog as-is, or a
        bare file name typed by hand, which is looked up inside DATA_DIR."""
        raw = str(file_path).strip()
        if not raw:
            raise ValueError("File name must not be empty.")

        candidate = Path(raw)
        if candidate.is_file():
            return str(candidate)

        name = candidate.name
        if not name.lower().endswith(".json"):
            name += ".json"
        return str(DATA_DIR / name)

    # -------------------------
    # UI helpers
    # -------------------------

    def refresh_all_views(self):
        self.main_window.refresh_users(self.graph.get_users())
        self.main_window.refresh_graph(self.graph)

    def handle_error(self, error):
        self.main_window.show_error(str(error))