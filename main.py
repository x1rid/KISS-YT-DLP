"""
YTDLP-GUI Application Entry Point.
"""

from __future__ import annotations

import sys

from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QApplication

from app.main_window import MainWindow
from app.styles import DARK_STYLESHEET


def main() -> None:
    # High-DPI support is enabled by default in Qt6
    app = QApplication(sys.argv)
    app.setApplicationName("YTDLP-GUI")
    app.setStyleSheet(DARK_STYLESHEET)

    window = MainWindow()
    window.show()

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
