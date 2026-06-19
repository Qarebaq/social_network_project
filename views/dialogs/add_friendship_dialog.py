from PySide6.QtWidgets import QDialog

""" Add friendship dialog. This module defines a Qt dialog for selecting two users and requesting the creation of a friendship between them. """

class AddFriendshipDialog(QDialog):

    def __init__(self, users=None, parent=None):
        super().__init__(parent)

        self.users = users or []

        self._setup_ui()
        self._connect_signals()

    def _setup_ui(self):
        # TODO: create user1 and user2 selection fields
        pass

    def _connect_signals(self):
        # TODO: connect OK and Cancel buttons
        pass

    def set_users(self, users):
        # TODO: update users list in combo boxes
        pass

    def get_user1_id(self):
        # TODO: return selected first user id
        pass

    def get_user2_id(self):
        # TODO: return selected second user id
        pass

    def get_data(self):
        # TODO: return user1_id and user2_id together
        pass

    def validate_input(self):
        # TODO: validate selected users
        pass