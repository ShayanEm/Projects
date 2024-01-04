// Author: Shayan Eram
using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// Represents a card holder with card information and balance.
/// </summary>
public class CardHolder
{
    /// <summary>
    /// Gets or sets the card number.
    /// </summary>
    public string CardNum { get; set; }
    
    /// <summary>
    /// Gets or sets the PIN (Personal Identification Number).
    /// </summary>
    public int Pin { get; set; }

    /// <summary>
    /// Gets or sets the first name of the card holder.
    /// </summary>
    public string FirstName { get; set; }

    /// <summary>
    /// Gets or sets the last name of the card holder.
    /// </summary>
    public string LastName { get; set; }

    /// <summary>
    /// Gets or sets the current balance of the card holder.
    /// </summary>
    public decimal Balance { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="CardHolder"/> class.
    /// </summary>
    /// <param name="cardNum">The card number.</param>
    /// <param name="pin">The PIN (Personal Identification Number).</param>
    /// <param name="firstName">The first name of the card holder.</param>
    /// <param name="lastName">The last name of the card holder.</param>
    /// <param name="balance">The initial balance of the card holder.</param>
    public CardHolder(string cardNum, int pin, string firstName, string lastName, decimal balance)
    {
        CardNum = cardNum;
        Pin = pin;
        FirstName = firstName;
        LastName = lastName;
        Balance = balance;
    }
}

/// <summary>
/// Manages ATM operations.
/// </summary>
public class ATM
{
    private List<CardHolder> cardHolders; // List to store card holder data.

    /// <summary>
    /// Initializes a new instance of the <see cref="ATM"/> class.
    /// </summary>
    public ATM()
    {
        InitializeDatabase();
    }

    /// <summary>
    /// Populates card holder data.
    /// </summary>
    private void InitializeDatabase()
    {
        cardHolders = new List<CardHolder>
        {
            // Sample card holder data.
            new CardHolder("0000000000000000", 1234, "Root", "Root", 1000.00m),
            new CardHolder("5415976839408707", 1895, "Brad", "Pitt", 321.13m),
            new CardHolder("6601787331974436", 7037, "Lady", "Gaga", 2000.23m),
            new CardHolder("6817274631190777", 7407, "Ryan", "Reynolds", 851.85m),
            new CardHolder("3088844710504399", 8178, "Scarlett ", "Johansson", 54.27m)
        };
    }

    /// <summary>
    /// Starts the ATM and manages user interactions.
    /// </summary>
    public void Run()
    {
        Console.ForegroundColor= ConsoleColor.Blue;
        Console.WriteLine("Welcome to Bank of Shayan ATM");
        Console.ResetColor();
        Console.WriteLine("Default card number: 0000000000000000");
        Console.WriteLine("Default Password: 1234");
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

    /// <summary>
    /// Displays the ATM menu options.
    /// </summary>
    private void PrintOptions()
    {
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine("Please choose from one of the following options...");
        Console.WriteLine("1. Deposit");
        Console.WriteLine("2. Withdraw");
        Console.WriteLine("3. Show balance");
        Console.WriteLine("4. Exit");
    }

    /// <summary>
    /// Handles deposit operation.
    /// </summary>
    /// <param name="currentUser">The current card holder.</param>
    private void Deposit(CardHolder currentUser)
    {
        Console.WriteLine("How much money would you like to deposit: ");
        decimal deposit = decimal.Parse(Console.ReadLine());
        currentUser.Balance += deposit;
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Thank you for your deposit. Your current balance is: " + currentUser.Balance);
        Console.ResetColor();
    }

    /// <summary>
    /// Handles withdrawal operation.
    /// </summary>
    /// <param name="currentUser">The current card holder.</param>
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

    /// <summary>
    /// Displays the current balance.
    /// </summary>
    /// <param name="currentUser">The current card holder.</param>
    private void ShowBalance(CardHolder currentUser)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Current balance: " + currentUser.Balance);
        Console.ResetColor();
    }
}

/// <summary>
/// Entry point of the program.
/// </summary>
public class Program
{
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    /// <param name="args">The command-line arguments.</param>
    public static void Main(string[] args)
    {
        // Create an instance of the ATM and start the program.
        ATM atm = new ATM();
        atm.Run();
    }
}