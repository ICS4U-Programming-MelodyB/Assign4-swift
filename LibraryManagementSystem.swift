import Foundation

// Define input & output paths.
let inputFile = "input.txt"
let outputFile = "output.txt"

// Read input file.
do {
    let inputString = try String(contentsOfFile: inputFile, encoding: .utf8)
    let inputLines = inputString.components(separatedBy: .newlines)
    
    // Process the commands and generate the outputs.
    let libraryInventory = LibraryInventory()
    var outputs: [String] = []
    
    for command in inputLines {
        let output = libraryInventory.processCommand(command)
        outputs.append(output)
    }
    
    // Create the output string.
    let outputString = "Output:\n" + "==============================\n\n" + outputs.joined(separator: "")
    
    // Write the output string to the file.
    do {
        try outputString.write(toFile: outputFile, atomically: true, encoding: .utf8)
        print("Output file generated successfully.")
    } catch {
        print("Error: Failed to write output file. \(error)")
        exit(1)
    }
} catch {
    print("Error: Failed to read input file. \(error)")
    exit(1)
}


class Book {
    let id: Int
    let title: String
    let author: String
    let publisher: String
    let publicationDate: String
    
    init(id: Int, title: String, author: String, publisher: String, publicationDate: String) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.publicationDate = publicationDate
    }
}

class Member {
    let id: Int
    let name: String
    var borrowedBooks: [Book] = []
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func borrowBook(_ book: Book) {
        borrowedBooks.append(book)
    }
    
    func returnBook(_ book: Book) {
        if let index = borrowedBooks.firstIndex(where: { $0.id == book.id }) {
            borrowedBooks.remove(at: index)
        }
    }
}

class LibraryInventory {
    var books: [Book] = []
    var members: [Member] = []
    
    func processCommand(_ command: String) -> String {
        let components = command.components(separatedBy: ",")
        let operation = components[0]
        
        switch operation {
        case "AddBook":
            let title = components[1]
            let author = components[2]
            let publisher = components[3]
            let publicationDate = components[4]
            let book = Book(id: books.count + 1, title: title, author: author, publisher: publisher, publicationDate: publicationDate)
            if let existingBook = findBook(withTitle: title) {
                return "Book already exists in the inventory: \(existingBook.title)\n"
            } else {
                books.append(book)
                return "Book added: \(book.title)\n"
            }
            
        case "SignUp":
            let memberName = components[1]
            let member = Member(id: members.count + 1, name: memberName)
            members.append(member)
            return "Member signed up: \(member.name)\n"
            
        case "SignIn":
            let memberName = components[1]
            if let member = members.first(where: { $0.name == memberName }) {
                return "Member signed in: \(member.name)\n"
            } else {
                return "Invalid command: \(operation)\n"
            }
            
        case "BorrowBook":
            let bookTitle = components[1]
            let memberName = components[2]
            guard let book = findBook(withTitle: bookTitle) else {
                return "Book not found: \(bookTitle)\n"
            }
            guard let member = findMember(withName: memberName) else {
                return "Member not found: \(memberName)\n"
            }
            member.borrowBook(book)
            return "Book borrowed: \(book.title)\n"
            
        case "ReturnBook":
            let bookTitle = components[1]
            let memberName = components[2]
            guard let book = findBook(withTitle: bookTitle) else {
                return "Book not found: \(bookTitle)\n"
            }
            guard let member = findMember(withName: memberName) else {
                return "Member not found: \(memberName)\n"
            }
            member.returnBook(book)
            return "Book returned: \(book.title) by \(member.name)\n"
            
        case "DonateBook":
            let title = components[1]
            let author = components[2]
            let publisher = components[3]
            let publicationDate = components[4]
            let book = Book(id: books.count + 1, title: title, author: author, publisher: publisher, publicationDate: publicationDate)
            books.append(book)
            return "Book donated: \(book.title) by \(author)\n"
            
        case "PrintInventory":
            var inventoryString = "Inventory:\n"
            for book in books {
                inventoryString += "Book: \(book.title)\n"
                inventoryString += "Author: \(book.author)\n"
                inventoryString += "Publisher: \(book.publisher)\n"
                inventoryString += "Publication Date: \(book.publicationDate)\n\n"
            }
            return inventoryString
            
        case "PRINT_MEMBERS":
            var membersString = ""
            for member in members {
                membersString += "Member ID: \(member.id)\n"
                membersString += "Member Name: \(member.name)\n"
                membersString += "Amount Owed: $0.0\n\n"
            }
            return membersString
            
        default:
            return "Invalid command: \(operation)\n"
        }
    }
    
    private func findBook(withTitle title: String) -> Book? {
        return books.first(where: { $0.title == title })
    }
    
    private func findMember(withName name: String) -> Member? {
        return members.first(where: { $0.name == name })
    }
}