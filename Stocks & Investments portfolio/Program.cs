using System;
using MyApp;

namespace MyApp
{
    /// <summary>
    /// Entry point of the program.
    /// </summary>
    public class Program
    {
        /// <summary>
        /// Main method that serves as the entry point of the application.
        /// </summary>
        /// <param name="args">Command-line arguments passed to the program.</param>
        public static void Main(string[] args)
        {
            Console.WriteLine("Welcome to stock Portfolio!");
            Console.WriteLine("Choose your option: ");
            Console.WriteLine("1. Show stocks");
            Console.WriteLine("2. Access your portfolio");

            int choice = int.Parse(Console.ReadLine());

            switch (choice)
            {
                case 1:
                    // Run default API to find stock prices
                    char continueStr = 'y';
                    while (continueStr == 'y')
                    {
                        Console.WriteLine("Enter a stock ticker that you want historic data for: ");
                        string symbol = Console.ReadLine().ToUpper();
                        Console.WriteLine("Enter the amount of months of historic data that you want to retrieve: ");
                        int timespan = Convert.ToInt32(Console.ReadLine());

                        DateTime endDate = DateTime.Today;
                        DateTime starDate = DateTime.Today.AddMonths(-timespan);

                        StockData stock = new StockData();
                        var awaiter = stock.getStockDtata(symbol, starDate, endDate);
                        if (awaiter.Result == 1)
                        {
                            Console.WriteLine();
                            Console.WriteLine("Do you want to get historical data for another ticker? (y/n)");
                            continueStr = Convert.ToChar(Console.ReadLine());
                        }
                    }
                    break;

                case 2:
                    // Create an instance of the StockPortfolio.
                    StockPortfolio StockPortfolio = new StockPortfolio();
                    StockPortfolio.Run();
                    break;

                default:
                    break;
            }
        }
    }
}
