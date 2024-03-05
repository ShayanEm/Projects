// Author: Shayan Eram
using System;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using RestSharp;
using MyApp;

namespace MyApp
{
    /// <summary>
    /// Represents a class to manage the StockPortfolio operations.
    /// </summary>
    public class StockPortfolio
    {
        private List<AccHolder> accHolders; // List to store acc holder data.

        /// <summary>
        /// Initializes a new instance of the <see cref="StockPortfolio"/> class and populates account holder data.
        /// </summary>
        public StockPortfolio()
        {
            InitializeDatabase();
        }

        /// <summary>
        /// Populates account holder data.
        /// </summary>
        private void InitializeDatabase()
        {
            accHolders = new List<AccHolder>
        {
            // Sample acc holder data.
            new AccHolder("root", 0000, "admin", "root", 1000.00m),
            new AccHolder("MasterInvestor", 1234, "Shayan", "Eram", 321.13m),
            new AccHolder("LadyInvestor", 7037, "Lady", "Gaga", 2000.23m),
            new AccHolder("RyanInvestor", 7407, "Ryan", "Reynolds", 851.85m),
            new AccHolder("ScarletteInvestor", 8178, "Scarlett ", "Johansson", 54.27m)
        };
        }

        /// <summary>
        /// Starts the StockPortfolio and manages user interactions.
        /// </summary>
        public void Run()
        {
            Console.ForegroundColor = ConsoleColor.Blue;
            Console.WriteLine("Welcome to your Stock Portfolio");
            Console.ResetColor();
            Console.WriteLine("---------------------");
            Console.WriteLine("Please enter your username: ");
            string username = "";
            AccHolder currentUser = null;

            // Loop to validate and authenticate the card.
            while (currentUser == null)
            {
                try
                {
                    username = Console.ReadLine();
                    currentUser = accHolders.FirstOrDefault(a => a.AccNum == username);

                    if (currentUser == null)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine("username not recognized. Please try again!");
                        Console.ResetColor();
                    }
                }
                catch
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("username not recognized. Please try again!");
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
                        StockDataByKey();
                        break;
                    case 5:
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
            while (option != 5);
        }

        /// <summary>
        /// Displays the StockPortfolio menu options.
        /// </summary>
        private void PrintOptions()
        {
            Console.WriteLine("--------------------------------------------------");
            Console.WriteLine("Please choose from one of the following options...");
            Console.WriteLine("1. Sell stocks");
            Console.WriteLine("2. Buy stocks");
            Console.WriteLine("3. Show balance");
            Console.WriteLine("4. Show stocks");
            Console.WriteLine("5. Exit");
        }

        /// <summary>
        /// Handles deposit operation.
        /// </summary>
        /// <param name="currentUser">The current account holder.</param>
        private void Deposit(AccHolder currentUser)
        {
            Console.WriteLine("How much stocks would you like to sell?: ");
            decimal deposit = decimal.Parse(Console.ReadLine());
            currentUser.Balance += deposit;
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Thank you for your deposit. Your current balance is: " + currentUser.Balance);
            Console.ResetColor();
        }

        /// <summary>
        /// Handles withdrawal operation.
        /// </summary>
        /// <param name="currentUser">The current account holder.</param>
        private void Withdraw(AccHolder currentUser)
        {
            Console.WriteLine("How much stocks would you like to buy?: ");
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
        /// <param name="currentUser">The current account holder.</param>
        private void ShowBalance(AccHolder currentUser)
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Current balance: " + currentUser.Balance);
            Console.ResetColor();
        }

        /// <summary>
        /// Retrieves stock data using a custom API key.
        /// </summary>
        private void StockDataByKey()
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("This option only works if have a personal API key in your account!");
            Console.ResetColor();
            Console.WriteLine("Which company's stocks do you want to see? Enter their ticker: ");

            var ticker = Console.ReadLine().ToUpper();

            var client = new RestClient("https://************************/");

            var request = new RestRequest(ticker + "/********************************", Method.Get);

            var response = client.Get(request);

            var json = JObject.Parse(response.Content);

            Console.WriteLine(json["results"]);

            Console.WriteLine(response.Content);
        }
    }
}
