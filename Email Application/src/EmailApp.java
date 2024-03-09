import java.util.Scanner;

/**
 * The EmailApp class represents the main application for managing email accounts.
 */
public class EmailApp {
    /**
     * The main method to start the Email Application.
     * @param args Command-line arguments (not used).
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Welcome to the Email Application!");

        System.out.print("Enter your first name: ");
        String firstName = scanner.nextLine();

        System.out.print("Enter your last name: ");
        String lastName = scanner.nextLine();

        Email em1 = new Email(firstName, lastName);

        System.out.println("\nYour account has been successfully created!");
        System.out.println(em1.showInfo());

        displayMenu(em1, scanner);
    }

    /**
     * Displays the menu and handles user choices.
     * @param email The Email object representing the user's email account.
     * @param scanner The Scanner object for user input.
     */
    private static void displayMenu(Email email, Scanner scanner) {
        boolean quit = false;
        while (!quit) {
            System.out.println("\nMenu:");
            System.out.println("1. Change Password");
            System.out.println("2. Set Alternate Email");
            System.out.println("3. Change Mailbox Capacity");
            System.out.println("4. Quit");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    System.out.print("Enter new password: ");
                    String newPassword = scanner.nextLine();
                    email.changePassword(newPassword);
                    System.out.println("Password changed successfully!");
                    break;
                case 2:
                    System.out.print("Enter alternate email: ");
                    String altEmail = scanner.nextLine();
                    email.setAlternateEmail(altEmail);
                    System.out.println("Alternate email set successfully!");
                    break;
                case 3:
                    System.out.print("Enter new mailbox capacity: ");
                    int newCapacity = scanner.nextInt();
                    email.setMailBoxCapacity(newCapacity);
                    System.out.println("Mailbox capacity changed successfully!");
                    break;
                case 4:
                    quit = true;
                    System.out.println("Thank you for using the Email Application!");
                    break;
                default:
                    System.out.println("Invalid choice! Please enter a valid option.");
            }
        }
    }
}
