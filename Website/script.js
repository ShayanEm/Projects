/**
 * @file script.js
 * @brief JavaScript file for Shayan's website.
 * 
 * Contains functions for handling user interactions and displaying alerts.
 *
 * @author Shayan Eram
 */

/**
 * @function showClickAlert
 * @brief Displays an alert when the logo is clicked.
 * @details This function is triggered by the onclick event of the logo.
 * 
 * @memberof global
 */
document.addEventListener('DOMContentLoaded', function() {
    // Logo click event
    document.getElementById('logo').addEventListener('click', function() {
        alert("Welcome to Nature Exploration!"); 
    });

    // Begin Exploration button click event
    document.getElementById('exploreButton').addEventListener('click', function() {
        alert("Get ready to embark on an exciting journey through nature!"); 
    });

    // Contact Us button click event
    document.getElementById('contactButton').addEventListener('click', function() {
        alert("Have questions or need assistance? Feel free to contact us!"); 
    });

    // Navbar links click events
    document.getElementById('homeLink').addEventListener('click', function() {
        alert("Lets go back Home"); 
    });

    document.getElementById('riverLink').addEventListener('click', function() {
        alert("Lets go fishing!"); 
    });

    document.getElementById('treeLink').addEventListener('click', function() {
        alert("Lets go camping!"); 
    });

    document.getElementById('rockLink').addEventListener('click', function() {
        alert("Lets go hiking!"); 
    });

    document.getElementById('seaLink').addEventListener('click', function() {
        alert("Lets go surfing!"); 
    });
});
