import json
import os

# File to store the library data
LIBRARY_FILE = 'library_data.json'

# Function to load Library data from a file
def load_library():
    if not os.path.exists(LIBRARY_FILE):
        return {}
    try:
        with open(LIBRARY_FILE, 'r') as file:
            return json.load(file)
    except Exception as e:
        print(f"Error loading library data: {e}")
        return {}

# Function to save Library data to a file
def save_library(library):
    try:
        with open(LIBRARY_FILE, 'w') as file:
            json.dump(library, file, indent=4) # Added indent for better readability
    except Exception as e:
        print(f"Error saving library data: {e}")

# Function to add a book to the library
def add_book(library, title, author, quantity):
    if title in library:
        print("Book already exists. Updating the quantity.")
        library[title]['quantity'] += quantity
    else:
        library[title] = {'author': author, 'quantity': quantity, 'borrowed_by': None}
    save_library(library)
    print(f"Book '{title}' added successfully!")

# Function to view all books in the library
def view_books(library):
    if not library:
        print("The library is empty.")
        return

    for title, details in library.items():
        status = f"Available ({details['quantity']})" if not details['borrowed_by'] else f"Borrowed by {details['borrowed_by']}"
        print(f"Title: {title}, Author: {details['author']}, Status: {status}")

# Function to borrow a book from the library
def borrow_book(library, title, borrower_name):
    if title not in library:
        print("Book not found in the library.")
        return

    if library[title]['quantity'] == 0:
        print(f"All copies of '{title}' are currently borrowed.")
        return

    if library[title]['borrowed_by']:
        print(f"The book '{title}' is currently borrowed by {library[title]['borrowed_by']}.")
        return

    library[title]['quantity'] -= 1 # Decrement quantity when borrowed
    library[title]['borrowed_by'] = borrower_name
    save_library(library)
    print(f"'{title}' has been borrowed by {borrower_name}.")

# Function to return a borrowed book to the library
def return_book(library, title):
    if title not in library:
        print("Book not found in the library.")
        return

    if not library[title]['borrowed_by']:
        print(f"The book '{title}' was not borrowed.")
        return

    borrower_name = library[title]['borrowed_by'] # Get borrower name before clearing
    library[title]['quantity'] += 1
    library[title]['borrowed_by'] = None
    save_library(library)
    print(f"'{title}' has been returned by {borrower_name}.")


# Main function to run the Library Management System
def main():
    library = load_library() # Load library data at the start

    # --- Simulation of user interaction for demonstration ---
    # Replaced input() calls with predefined values to avoid EOFError
    print("\n--- Simulating Library Operations ---")

    # Simulate adding a book
    print("\nSimulating: Add Book")
    add_book(library, "The Hitchhiker's Guide to the Galaxy", "Douglas Adams", 5)

    # Simulate viewing books
    print("\nSimulating: View Books")
    view_books(library)

    # Simulate borrowing a book
    print("\nSimulating: Borrow Book")
    borrow_book(library, "The Hitchhiker's Guide to the Galaxy", "Arthur Dent")

    # Simulate viewing books again
    print("\nSimulating: View Books after borrowing")
    view_books(library)

    # Simulate returning a book
    print("\nSimulating: Return Book")
    return_book(library, "The Hitchhiker's Guide to the Galaxy")

    # Simulate viewing books after returning
    print("\nSimulating: View Books after returning")
    view_books(library)

    # Simulate exiting
    print("\nSimulating: Exit")
    print("Exiting the system. Goodbye!")
    # --- End of Simulation ---

    # Original interactive loop (commented out)
    # while True:
    #     print("\nLibrary Management System")
    #     print("1. Add Book")
    #     print("2. View Books")
    #     print("3. Borrow Book")
    #     print("4. Return Book")
    #     print("5. Exit")
    #
    #     choice = input("Enter your choice: ")
    #
    #     if choice == '1':
    #         title = input("Enter the book title: ")
    #         author = input("Enter the book author: ")
    #         try:
    #             quantity = int(input("Enter the quantity of the book: "))
    #             add_book(library, title, author, quantity)
    #         except ValueError:
    #             print("Invalid input for quantity. Please enter an integer.")
    #
    #     elif choice == '2':
    #         view_books(library)
    #
    #     elif choice == '3':
    #         title = input("Enter the book title: ")
    #         borrower_name = input("Enter your name: ")
    #         borrow_book(library, title, borrower_name)
    #
    #     elif choice == '4':
    #         title = input("Enter the book title: ")
    #         return_book(library, title)
    #
    #     elif choice == '5':
    #         print("Exiting the system. Goodbye!")
    #         break
    #
    #     else:
    #         print("Invalid choice. Please enter a number between 1 and 5.")

if __name__ == "__main__":
    main()
