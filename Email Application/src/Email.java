import java.security.SecureRandom;
import java.util.Scanner;

/**
 * The Email class represents an email account.
 */
public class Email {
    private String firstName;
    private String lastName;
    private String password;
    private String department;
    private int mailBoxCapacity = 500;
    private String alternateEmail;
    private String email;
    private String companySuffix = "shayanware.com";

    /**
     * Constructs an Email object with the given first name and last name.
     * @param firstName The first name of the user.
     * @param lastName The last name of the user.
     */
    public Email(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;

        this.department = setDepartment();

        this.password = generateRandomPassword(12); // Generating a stronger password

        this.email = generateEmail();
    }

    /**
     * Prompts the user to select a department and returns the department code.
     * @return The department code (e.g., "sales", "dev", "acct").
     */
    private String setDepartment() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the department:\n1 for Sales\n2 for Development\n3 for Accounting\n0 for none");
        int depChoice;
        do {
            System.out.print("Your choice: ");
            while (!scanner.hasNextInt()) {
                System.out.println("Invalid input. Please enter a number.");
                scanner.next();
            }
            depChoice = scanner.nextInt();
        } while (depChoice < 0 || depChoice > 3);

        switch (depChoice) {
            case 1:
                return "sales";
            case 2:
                return "dev";
            case 3:
                return "acct";
            default:
                return "";
        }
    }

    /**
     * Generates a random password of the specified length.
     * @param length The length of the password.
     * @return The generated password.
     */
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(chars.length());
            password.append(chars.charAt(randomIndex));
        }
        return password.toString();
    }

    /**
     * Generates the email address based on the user's information and department.
     * @return The generated email address.
     */
    private String generateEmail() {
        return firstName.toLowerCase() + "." + lastName.toLowerCase() + "@" + department + "." + companySuffix;
    }

    /**
     * Sets the mailbox capacity to the specified value.
     * @param capacity The new mailbox capacity.
     */
    public void setMailBoxCapacity(int capacity) {
        this.mailBoxCapacity = capacity;
    }

    /**
     * Sets the alternate email address.
     * @param altEmail The alternate email address.
     */
    public void setAlternateEmail(String altEmail) {
        this.alternateEmail = altEmail;
    }

    /**
     * Changes the password to the specified value.
     * @param newPassword The new password.
     */
    public void changePassword(String newPassword) {
        this.password = newPassword;
    }

    /**
     * Gets the mailbox capacity.
     * @return The mailbox capacity.
     */
    public int getMailBoxCapacity() {
        return mailBoxCapacity;
    }

    /**
     * Gets the alternate email address.
     * @return The alternate email address.
     */
    public String getAlternateEmail() {
        return alternateEmail;
    }

    /**
     * Gets the password.
     * @return The password.
     */
    public String getPassword() {
        return password;
    }

    /**
     * Returns the user's information and email address.
     * @return A string representation of the user's information.
     */
    public String showInfo() {
        return "Display name: " + firstName + " " + lastName + "\nCompany email: " + email + "\nMailbox capacity: " + mailBoxCapacity + " MB";
    }
}