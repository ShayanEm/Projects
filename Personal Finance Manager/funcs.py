from unicodedata import category
from expense import Expense
import calendar
import datetime


def get_user_expense():
    """
    Get user expense details.

    Returns:
        Expense: An Expense object containing user input details.
    """
    print("Getting user expense")
    expense_name = input("Enter expense name:")
    
    while True:
        try:
            expense_amount = float(input("Enter expense amount:"))
            break
        except ValueError:
            print("Invalid input! Please enter a valid number.")

    expense_categories = [ "Food", "Home", "Work", "Fun", "Misc"]

    while True:
        print("Select a category:")
        
        for i, category_name in enumerate(expense_categories, start=1):
            print(f" {i}. {category_name} ")

        value_range = f"[1 - {len(expense_categories)}]"

        try:
            selected_index = int(input(f"Enter category number {value_range}: ")) - 1
            if selected_index in range(len(expense_categories)): 
                selected_category = expense_categories[selected_index]
                new_expense = Expense(name=expense_name, category=selected_category, amount=expense_amount)
                return new_expense
            else:
                print("Invalid category. Please try again!")
        except ValueError:
            print("Invalid input! Please enter a valid category number.")


def save_expense_to_file(expense: Expense, expense_file_path):
    """
    Save expense details to a file.

    Args:
        expense (Expense): The Expense object to be saved.
        expense_file_path (str): The path to the expense file.
    """
    print(f"Saving user Expense: {expense} to {expense_file_path}")
    try:
        with open(expense_file_path, "a") as f:
            f.write(f"{expense.name},{expense.category},{expense.amount}\n")
    except IOError:
        print("Error: Unable to save expense to file.")


def summarize_expenses(expense_file_path, budget):
    """
    Summarize user expenses.

    Args:
        expense_file_path (str): The path to the expense file.
        budget (float): The budget amount.

    """
    print("Summarize user expense")
    expenses = []

    try:
        with open(expense_file_path, "r") as f:
            lines = f.readlines()
            for line in lines:
                expense_name, expense_category, expense_amount = line.strip().split(",")
                line_expense = Expense(name=expense_name, amount=float(expense_amount), category=expense_category)
                print(line_expense)
                expenses.append(line_expense)
    except FileNotFoundError:
        print("Error: Expense file not found.")

    amount_by_category = {}
    for expense in expenses:
        key = expense.category
        if key in amount_by_category:
            amount_by_category[key] += expense.amount
        else:
            amount_by_category[key] = expense.amount

    for key, amount in amount_by_category.items():
        print("Expenses By Category:")
        print(f"  {key}: ${amount:.2f}")

    total_spent = sum([ex.amount for ex in expenses])
    print(f"You've spent ${total_spent:.2f} this month!")

    remaining_budget = budget - total_spent
    print(f"Budget remaining ${remaining_budget:.2f}")

    now = datetime.datetime.now()
    days_in_month = calendar.monthrange(now.year, now.month)[1]
    remaining_days = days_in_month - now.day
    
    daily_budget = remaining_budget / remaining_days
    print(f"Budget per day: ${daily_budget:.2f}")


def writeSQLExpenses(cur,conn):
    """
    Write expense details to a SQLite database.

    Args:
        cur: The cursor object to interact with the database.
        conn: The connection object to the SQLite database.
    """
    # Input for expense details
    date = input("Enter the date of the expense (YYYY-MM-DD):")
    description = input("Enter the description of the expense:")

    # Retrieving categories from the database
    cur.execute("SELECT DISTINCT category FROM expenses")
    categories = cur.fetchall()

    # Displaying categories for selection
    print("Select a category by number: ")
    for idx, category in enumerate(categories):
        print(f"{idx + 1}.{category[0]}")
    print(f"{len(categories) + 1}. Create a new category")

    category_choice = int(input())
    if category_choice == len(categories) + 1:
        category = input("Enter the new category name:")
    else:
        category = categories[category_choice - 1][0]

    price = input("Enter the price of the expense: ")

    # Format date
    formatted_date = datetime.datetime.strptime(date, "%Y-%m-%d").date()

    # Inserting data into the database
    cur.execute("INSERT INTO expenses (date, description, category, price) VALUES (?, ?, ?, ?)", (formatted_date, description, category, price))
    conn.commit()

    # Verifying if data is inserted properly
    cur.execute("SELECT * FROM expenses WHERE date=?", (formatted_date,))
    print(cur.fetchall())


def readSQLExpenses(cur):
    """
    Read expense details from a SQLite database.

    Args:
        cur: The cursor object to interact with the database.
    """
    print("Select an option")
    print("1. view all expenses")
    print("2. view monthly expenses by category")

    view_choice = int(input())
    if view_choice == 1:
        # Viewing all expenses
        cur.execute("SELECT * FROM expenses")
        expenses = cur.fetchall()
        for expense in expenses:
            print(expense)

    elif view_choice == 2:
        # Viewing monthly expenses by category
        month = input("Enter the month (MM): ")
        year = input("Enter the year (YYYY):")
        cur.execute("SELECT category, SUM(price) FROM expenses WHERE strftime('%m', date) = ? AND strftime('%Y', date) = ? GROUP BY category", (month, year))
        expenses = cur.fetchall()
        for expense in expenses:
            print(f"Category: {expense[0]}, Total: {expense[1]}")
    else:
        exit()
