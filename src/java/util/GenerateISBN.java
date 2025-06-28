/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import dao.implement.BookManagementDAO;
import java.util.Random;

/**
 *
 * @author asus
 */
public class GenerateISBN {

      private final BookManagementDAO bookManagementDAO = new BookManagementDAO();

      public  String generateUniqueISBN() {
            String isbn;
            int attempts = 0;
            final int maxAttempts = 100;

            do {
                  isbn = generateRandomISBN13();
                  attempts++;

                  if (attempts > maxAttempts) {
                        throw new RuntimeException("Unable to generate unique ISBN after " + maxAttempts + " attempts");
                  }

            } while (isIsbnExists(isbn));

            return isbn;
      }

//       Generate random ISBN-13 format: 978-XXXXXXXXX
      private String generateRandomISBN13() {
            Random random = new Random();
            StringBuilder isbn = new StringBuilder("978");

            // Generate 9 random digits
            for (int i = 0; i < 9; i++) {
                  isbn.append(random.nextInt(10));
            }

            // Calculate and append check digit
            String isbnWithoutCheck = isbn.toString();
            int checkDigit = calculateISBN13CheckDigit(isbnWithoutCheck);
            isbn.append(checkDigit);

            return isbn.toString();
      }

//       Calculate ISBN-13 check digit
      private int calculateISBN13CheckDigit(String isbn12) {
            int sum = 0;
            for (int i = 0; i < 12; i++) {
                  int digit = Character.getNumericValue(isbn12.charAt(i));
                  if (i % 2 == 0) {
                        sum += digit;
                  } else {
                        sum += digit * 3;
                  }
            }
            int remainder = sum % 10;
            return remainder == 0 ? 0 : 10 - remainder;
      }

//       Check if ISBN exists (overloaded method for convenience)
      private boolean isIsbnExists(String isbn) {
            try {
                  return bookManagementDAO.isIsbnExists(isbn);
            } catch (Exception e) {
                  throw new RuntimeException("Error checking ISBN existence: " + e.getMessage(), e);
            }
      }
}
