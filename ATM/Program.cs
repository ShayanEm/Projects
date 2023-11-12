using System;
using System.Collections.Generic;
using System.Linq;

// Define a class to represent a card holder with card information and balance.
public class CardHolder
{
    // Properties to store card details and balance.
    public string CardNum { get; set; }
    public int Pin { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public decimal Balance { get; set; }

    // Constructor to initialize card holder properties.
    public CardHolder(string cardNum, int pin, string firstName, string lastName, decimal balance)
    {
        CardNum = cardNum;
        Pin = pin;
        FirstName = firstName;
        LastName = lastName;
        Balance = balance;
    }
}

// Define a class to manage the ATM operations.
public class ATM
{
    private List<CardHolder> cardHolders; // List to store card holder data.

    // Constructor to initialize the ATM and populate card holder data.
    public ATM()
    {
        InitializeDatabase();
    }

    // Method to populate card holder data.
    private void InitializeDatabase()
    {
        cardHolders = new List<CardHolder>
        {
            // Sample card holder data.
            new CardHolder("9541192939389400", 1234, "Shayan", "Eram", 1000.00m),
            new CardHolder("5415976839408707", 1895, "Brad", "Pitt", 321.13m),
            new CardHolder("6601787331974436", 7037, "Lady", "Gaga", 2000.23m),
            new CardHolder("6817274631190777", 7407, "Ryan", "Reynolds", 851.85m),
            new CardHolder("3088844710504399", 8178, "Scarlett ", "Johansson", 54.27m)
        };
    }

    // Method to start the ATM and manage user interactions.
    public void Run()
    {
        Console.ForegroundColor= ConsoleColor.Blue;
        Console.WriteLine("Welcome to Shayan ATM");
        Console.ResetColor();
        Console.WriteLine("---------------------");
        Console.WriteLine("Please insert your debit card: ");
        string debitCardNum = "";
        CardHolder currentUser = null;

        // Loop to validate and authenticate the card.
        while (currentUser == null)
        {
            try
            {
                debitCardNum = Console.ReadLine();
                currentUser = cardHolders.FirstOrDefault(a => a.CardNum == debitCardNum);

                if (currentUser == null)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Card not recognized. Please try again!");
                    Console.ResetColor();
                }
            }
            catch
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Card not recognized. Please try again!");
                Console.ResetColor();
            }
        }

        Console.WriteLine("Please enter your PIN: ");
        int userPin = 0;

        // Loop to validate the PIN.
        while (true)
        {
            try
            {
                userPin = int.Parse(Console.ReadLine());

                if (currentUser.Pin == userPin)
                {
                    break;
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Incorrect PIN. Please try again.");
                    Console.ResetColor();
                }
            }
            catch
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Incorrect PIN. Please try again.");
                Console.ResetColor();
            }
        }

        Console.WriteLine("---------------------------------");
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Welcome, " + currentUser.FirstName);
        Console.ResetColor();

        int option = 0;
        do
        {
            PrintOptions();

            try
            {
                option = int.Parse(Console.ReadLine());
            }
            catch
            {
                option = 0;
            }

            // Switch statement to handle user menu options.
            switch (option)
            {
                case 1:
                    Deposit(currentUser);
                    break;
                case 2:
                    Withdraw(currentUser);
                    break;
                case 3:
                    ShowBalance(currentUser);
                    break;
                case 4:
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Thank you! Have a nice day!");
                    Console.ResetColor();
                    break;
                default:
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Invalid option. Please try again.");
                    Console.ResetColor();
                    break;
            }
        }
        while (option != 4);
    }

    // Method to display the ATM menu options.
    private void PrintOptions()
    {
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine("Please choose from one of the following options...");
        Console.WriteLine("1. Deposit");
        Console.WriteLine("2. Withdraw");
        Console.WriteLine("3. Show balance");
        Console.WriteLine("4. Exit");
    }

    // Method to handle deposit operation.
    private void Deposit(CardHolder currentUser)
    {
        Console.WriteLine("How much money would you like to deposit: ");
        decimal deposit = decimal.Parse(Console.ReadLine());
        currentUser.Balance += deposit;
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Thank you for your deposit. Your current balance is: " + currentUser.Balance);
        Console.ResetColor();
    }

    // Method to handle withdrawal operation.
    private void Withdraw(CardHolder currentUser)
    {
        Console.WriteLine("How much money would you like to withdraw: ");
        decimal withdraw = decimal.Parse(Console.ReadLine());

        if (currentUser.Balance < withdraw)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("Insufficient balance.");
            Console.ResetColor();
        }
        else
        {
            currentUser.Balance -= withdraw;
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("You're good to go! Thank you. Your current balance is: " + currentUser.Balance);
            Console.ResetColor();
        }
    }

    // Method to display the current balance.
    private void ShowBalance(CardHolder currentUser)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Current balance: " + currentUser.Balance);
        Console.ResetColor();
    }
}

// Entry point of the program.
public class Program
{
    public static void Main(string[] args)
    {
        // Create an instance of the ATM and start the program.
        ATM atm = new ATM();
        atm.Run();
    }
}