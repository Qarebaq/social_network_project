"""
run_qml_preview.py
-------------------
Standalone launcher just to LOOK AT the QML UI (login -> dashboard) while
it's being built, without needing MainController / GraphFacade / the
repository wired up yet.

Run it from the `views/` folder:

    pip install PySide6
    python run_qml_preview.py

Once the UI is ready to be connected to the real app, this file should be
replaced by proper wiring inside main.py (see the PDF, section
"Controller wiring", for the two options: embedding via QQuickWidget
inside the existing QWidget MainWindow, or switching main.py to
QQmlApplicationEngine entirely).
"""
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qml_entry_point = Path(__file__).parent / "qml" / "App.qml"
    engine.load(str(qml_entry_point))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
