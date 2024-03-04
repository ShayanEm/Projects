from unicodedata import category
from expense import Expense
import funcs as fcn
import calendar
import datetime
import sqlite3
import sys


def main():
    """
    The main function to manage personal finance.

    Allows the user to choose between managing data using a CSV file or an SQL database.
    """
    print("...................................................")
    print("Welcome to your personal finance manager!")
    print("Choose which methode you want to use this time: ")
    print("1. CSV file")
    print("2. SQL database")
    print("...................................................")

    data_choice = int(input("Enter your choice (1 or 2): "))
    
    match data_choice:
        case 1:
            data_choice_one()
        case 2:
            data_choice_two()
        case _:
            print("Invalid choice!")
            sys.exit(1)

    print("Bye! See you later")
    print("...................................................")


def data_choice_one():
    """
    Manages finance data using a CSV file.
    
    Allows the user to write or read expenses from a CSV file.
    """
    print("You chose CSV file:")
    print("...................")

    expense_file_path = "expenses.csv"

    # Getting user budget for the month
    try:
        budget = float(input("what is you budget for this month?"))
    except ValueError:
        print("Invalid input! Please enter a valid number.")

    print("Which methode do you want: ")
    print("1. Write expenses: ")
    print("2. Read expenses: ")
    user_mode = int(input("Enter your choice (1 or 2): "))
    
    if user_mode == 1:
        # Get user for expense
        expense = fcn.get_user_expense()
        
        # Write their expense to a file
        fcn.save_expense_to_file(expense, expense_file_path)

    else:
        # Read file and summarize expense
        fcn.summarize_expenses(expense_file_path, budget)


def data_choice_two():
    """
    Manages finance data using an SQL database.
    
    Allows the user to write or read expenses from an SQL database.
    """
    print("You chose SQL data base:")
    print("........................")
    
    # Establishing connection to the SQLite database
    conn = sqlite3.connect("expenses.db")
    cur = conn.cursor()

    while True:
        print("Which methode do you want: ")
        print("1. Write expenses: ")
        print("2. Read expenses: ")

        # User input for choice
        choice = int(input("Enter your choice (1 or 2): "))

        # Choice 1
        if choice == 1:
            fcn.writeSQLExpenses(cur,conn)

        # Choice 2
        elif choice == 2:
            fcn.readSQLExpenses(cur)

        else:
            exit()

        # Asking user if they want to continue
        repeat = input("Would you like to do something else (y/n)?\n")
        if repeat.lower() != "y":
            break

    # Closing the database connection
    conn.close()

if __name__ == "__main__":
    main()