// Author: Shayan Eram
using System;
using System.Threading.Tasks;
using YahooFinanceApi;
using MyApp;

namespace MyApp
{
    /// <summary>
    /// Represents a class to retrieve stock data using a public API key.
    /// </summary>
    public class StockData
    {
        /// <summary>
        /// Retrieves historical stock data for a given symbol within a specified date range.
        /// </summary>
        /// <param name="symbol">The stock symbol.</param>
        /// <param name="starDate">The start date of the data range.</param>
        /// <param name="endDate">The end date of the data range.</param>
        /// <returns>An asynchronous task representing the operation.</returns>
        public async Task<int> getStockDtata(string symbol, DateTime starDate, DateTime endDate)
        {
            try
            {
                // Retrieve historical stock data
                var historical_data = await Yahoo.GetHistoricalAsync(symbol, starDate, endDate);
                var security = await Yahoo.Symbols(symbol).Fields(Field.LongName).QueryAsync();
                var ticker = security[symbol];
                var companyName = ticker[Field.LongName];

                // Print historical data
                for (int i = 0; i < historical_data.Count; i++)
                {
                    Console.WriteLine(companyName + "Closing price on: " + historical_data.ElementAt(i).DateTime.Month + "/" + historical_data.ElementAt(i).DateTime.Day + "/" + historical_data.ElementAt(i).DateTime.Year + ": $" + Math.Round(historical_data.ElementAt(i).Close), 2);
                }
            }
            catch
            {
                Console.WriteLine("Failed to get symbol: " + symbol);
            }
            return 1;
        }
    }
}
