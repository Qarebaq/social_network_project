from PySide6.QtWidgets import QDialog


class AddUserDialog(QDialog):


    def __init__(self, parent=None):
        super().__init__(parent)

        self._setup_ui()
        self._connect_signals()

    def _setup_ui(self):
        # TODO: create user_id and name input fields
        pass

    def _connect_signals(self):
        # TODO: connect OK and Cancel buttons
        pass

    def get_user_id(self):
        # TODO: return entered user id
        pass

    def get_user_name(self):
        # TODO: return entered user name
        pass

    def get_data(self):
        # TODO: return user_id and name together
        pass

    def validate_input(self):
        # TODO: validate dialog input
        pass