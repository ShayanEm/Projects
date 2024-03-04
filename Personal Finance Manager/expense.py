class Expense:
    """
    Expense class representing an expense object.
    """

    def __init__(self, name, category, amount) -> None:
        """
        Initialize Expense object with name, category, and amount.
        
        Args:
            name (str): Name of the expense.
            category (str): Category of the expense.
            amount (float): Amount of the expense.
        """
        self.name = name  # Initialize expense name
        self.category = category  # Initialize expense category
        self.amount = amount  # Initialize expense amount

    def __repr__(self):
        """
        Return a string representation of the Expense object.
        
        Returns:
            str: String representation of the Expense object.
        """
        return f"<Expense: {self.name}, {self.category}, ${self.amount:.2f}>"
        # Return string with expense details