// Author: Shayan Eram
using System;
using MyApp;

namespace MyApp
{
    /// <summary>
    /// Represents an account holder with account information.
    /// </summary>
    public class AccHolder
    {
        /// <summary>
        /// Gets or sets the account number.
        /// </summary>
        public string AccNum { get; set; }

        /// <summary>
        /// Gets or sets the PIN (Personal Identification Number).
        /// </summary>
        public int Pin { get; set; }

        /// <summary>
        /// Gets or sets the first name of the account holder.
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Gets or sets the last name of the account holder.
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// Gets or sets the balance of the account.
        /// </summary>
        public decimal Balance { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="AccHolder"/> class with the specified account details.
        /// </summary>
        /// <param name="accNum">The account number.</param>
        /// <param name="pin">The PIN (Personal Identification Number).</param>
        /// <param name="firstName">The first name of the account holder.</param>
        /// <param name="lastName">The last name of the account holder.</param>
        /// <param name="balance">The balance of the account.</param>
        public AccHolder(string accNum, int pin, string firstName, string lastName, decimal balance)
        {
            AccNum = accNum;
            Pin = pin;
            FirstName = firstName;
            LastName = lastName;
            Balance = balance;
        }
    }
}
