import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtWidgets import *
from PyQt5.QtWebEngineWidgets import *

class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()

        # Create a QWebEngineView widget and set the initial URL to Google
        self.browser = QWebEngineView()
        self.browser.setUrl(QUrl('http://google.com'))
        self.setCentralWidget(self.browser)
        self.showMaximized()

        # Create a navigation toolbar
        navbar = QToolBar()
        self.addToolBar(navbar)

        # Styling for toolbar buttons
        style = "QToolBar { border: none; background-color: #f0f0f0; }"
        navbar.setStyleSheet(style)

        # Create Back button and connect it to the browser's back action
        back_btn = QAction(QIcon('back_icon.png'), 'Back', self)
        back_btn.triggered.connect(self.browser.back)
        navbar.addAction(back_btn)

        # Create Forward button and connect it to the browser's forward action
        forward_btn = QAction(QIcon('forward_icon.png'), 'Forward', self)
        forward_btn.triggered.connect(self.browser.forward)
        navbar.addAction(forward_btn)

        # Create Reload button and connect it to the browser's reload action
        reload_btn = QAction(QIcon('reload_icon.png'), 'Reload', self)
        reload_btn.triggered.connect(self.browser.reload)
        navbar.addAction(reload_btn)

        # Create Home button and connect it to the custom navigate_home method
        home_btn = QAction(QIcon('home_icon.png'), 'Home', self)
        home_btn.triggered.connect(self.navigate_home)
        navbar.addAction(home_btn)

        # Create a QLineEdit widget for entering URLs and connect it to navigate_to_url method
        self.url_bar = QLineEdit()
        self.url_bar.returnPressed.connect(self.navigate_to_url)
        style = "QLineEdit { border: 1px solid #ccc; padding: 5px; background-color: white; }"
        self.url_bar.setStyleSheet(style)
        navbar.addWidget(self.url_bar)

        # Connect the browser's URL change signal to the update_url method
        self.browser.urlChanged.connect(self.update_url)

    def navigate_home(self):
        # Load Google's URL when the Home button is clicked
        self.browser.setUrl(QUrl('https://google.com'))

    def navigate_to_url(self):
        # Get the URL from the QLineEdit and load it in the browser
        url = self.url_bar.text()
        self.browser.setUrl(QUrl(url))

    def update_url(self, q):
        # Get the URL from the QLineEdit and load it in the browser
        self.url_bar.setText(q.toString())

app = QApplication(sys.argv)
QApplication.setApplicationName("Shayan Browser")

# Load custom icons
app.setWindowIcon(QIcon('browser_icon.png'))

window = MainWindow()
app.exec_()
