from PySide6.QtWidgets import QWidget
from PySide6.QtCore import Signal


class UserPanel(QWidget):
    """ User management panel. This module defines the Qt widget used for displaying users and requesting user or friendship operations such as adding, removing, editing, selecting users, and creating friendships. """

    add_user_requested = Signal()
    remove_user_requested = Signal(str)
    update_user_requested = Signal(str)
    add_friendship_requested = Signal()
    remove_friendship_requested = Signal(str, str)

    user_selected = Signal(str)

    def __init__(self):
        super().__init__()

        self._setup_ui()
        self._connect_signals()

    def _setup_ui(self):
        # TODO: create user list and buttons
        pass

    def _connect_signals(self):
        # TODO: connect buttons to signals
        pass

    def set_users(self, users):
        # TODO: display users in panel
        pass

    def get_selected_user_id(self):
        # TODO: return selected user id
        pass

    def clear_selection(self):
        # TODO: clear selected user
        pass

    def refresh(self):
        # TODO: refresh user list
        pass