"""
Author: Shayan Eram
"""
import sys
from PyQt5.QtWidgets import QMainWindow, QApplication,QPushButton, QLabel
from PyQt5 import uic

class UI(QMainWindow):
    """
    Class representing the main user interface for the Tic-Tac-Toe game.
    """

    def __init__(self):
        """
        Initializes the UI by loading the UI file and setting up the initial state.
        """

        super(UI,self).__init__() #makes the class visible to others
        uic.loadUi("Tik.ui",self) #Load the ui file
        self.setWindowTitle("Shayan TTT game")
        self.show() #show the app

        #Define counter to keep track of player turn
        self.counter = 0

        #Define winning color
        self.WIN_COLOR = 'red'

        #Define widgets
        self.button1 = self.findChild(QPushButton,"pushButton_1")
        self.button2 = self.findChild(QPushButton,"pushButton_2")
        self.button3 = self.findChild(QPushButton,"pushButton_3")
        self.button4 = self.findChild(QPushButton,"pushButton_4")
        self.button5 = self.findChild(QPushButton,"pushButton_5")
        self.button6 = self.findChild(QPushButton,"pushButton_6")
        self.button7 = self.findChild(QPushButton,"pushButton_7")
        self.button8 = self.findChild(QPushButton,"pushButton_8")
        self.button9 = self.findChild(QPushButton,"pushButton_9")
        self.button10 = self.findChild(QPushButton,"pushButton_10")
        self.label = self.findChild(QLabel, "label")

        #Click the button
        self.button1.clicked.connect(lambda:self.clicker(self.button1))
        self.button2.clicked.connect(lambda:self.clicker(self.button2))
        self.button3.clicked.connect(lambda:self.clicker(self.button3))
        self.button4.clicked.connect(lambda:self.clicker(self.button4))
        self.button5.clicked.connect(lambda:self.clicker(self.button5))
        self.button6.clicked.connect(lambda:self.clicker(self.button6))
        self.button7.clicked.connect(lambda:self.clicker(self.button7))
        self.button8.clicked.connect(lambda:self.clicker(self.button8))
        self.button9.clicked.connect(lambda:self.clicker(self.button9))
        self.button10.clicked.connect(self.reset)
    
    #Check for the win
    def checkWin(self):
        """
        Checks for a winning combination on the game board.
        """

        winning_combinations = [
            [self.button1, self.button4, self.button7],
            [self.button2, self.button5, self.button8],
            [self.button3, self.button6, self.button9],
            [self.button1, self.button2, self.button3],
            [self.button4, self.button5, self.button6],
            [self.button7, self.button8, self.button9],
            [self.button1, self.button5, self.button9],
            [self.button3, self.button5, self.button7]
            ]

        for a, b, c in winning_combinations:
            if a.text() == b.text() == c.text() and a.text() != '':
                self.win(a, b, c)

    def win(self, a, b, c):
        """
        Handles the win scenario by updating button styles and displaying the winner.
        """

        for btn in [a, b, c]:
            btn.setStyleSheet(f'QPushButton {{color: {self.WIN_COLOR}}}')
        self.label.setText(f"{a.text()} Wins!")
        self.disable()

    #Disable the board   
    def disable(self):
        #List of all buttons
        button_list = [self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, self.button9]
        
        #Reset buttons
        for b in button_list:
            b.setEnabled(False)

    #Click the button
    def clicker(self, b):
        """
        Handles button click events, marking the board and checking for a win.
        """

        if self.counter % 2 == 0:
            mark = 'X'
            self.label.setText("O turn")
        else:
            mark = 'O'
            self.label.setText("X turn")
        
        b.setText(mark)
        b.setEnabled(False)

        self.counter += 1

        #Check win
        self.checkWin()

    def reset(self):
        """
        Resets the game board, enabling buttons and resetting the counter.
        """

        button_list = [self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, self.button9]
        
        #Reset buttons
        for b in button_list:
            b.setText('')
            b.setEnabled(True)
            b.setStyleSheet('QPushButton {color: #797979}')

        #Reset the counter
        self.counter = 0
            
        #Reset label
        self.label.setText("X Goes first")

#Initilaze the app
app = QApplication(sys.argv)
UIWindow = UI()
app.exec_()