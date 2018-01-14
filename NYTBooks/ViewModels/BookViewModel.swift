//
//  BookViewModel.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

enum UIError: LocalizedError {
    case noNetwork
    case unknown
    case nobooks
    
    public var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "Network not availaible."
        case .unknown:
            return "Some problem occured. Please try again."
        case .nobooks:
            return "Books not availaible."
        }
    }
}

class BookViewModel: BookViewModelable {
    
    enum UIState {
        case displayBooks(books: [Book])
        case search(books: [[Book]])
        case nobooks(error: UIError) // Change it to enum
        case loading(message: String)
        case searchingBooks(message: String)
    }

    private struct Formatter {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }

    private var books: [Book] = []
    var state: Observer<BookViewModel.UIState> = Observer(.loading(message: "Fetching Data..."))
    private var previousSearchWord: String? = nil
    
    init() {
        fetchBooks(for: Date())
    }
}

// MARK: API request
extension BookViewModel {
    private func fetchBooks(for date: Date) {
        let date = Formatter.dateFormatter.string(from: date)
        NYTBookService.requestBooks(publishDate: date).fetchBooks().bindAndFire { [unowned self] (responseStauts) in
            DispatchQueue.main.async {
                switch responseStauts {
                case .loading:
                    self.state.value = .loading(message: "Fetching Data...")
                    print("Loading")
                case .success(let value):
                    print(value.getAllBooks())
                    self.books = value.getAllBooks()
                    if self.books.count == 0{
                        self.state.value = .nobooks(error: .nobooks)
                    }
                    self.state.value = .displayBooks(books: self.books)
                case .failure(let error):
                    print(error)
                    //Handle Errors
                    self.state.value = .nobooks(error: .unknown)
                }
            }
        }
    }
}

// MARK: Date handling
extension BookViewModel {
    func changeDate(date: Date) {
        fetchBooks(for: date)
    }
}

// MARK: Search Functionality
extension BookViewModel {
    func search(keyword: String) {
        if case .search(let filterBooks) = state.value {
            if let previousSearchWord = previousSearchWord, previousSearchWord.count < keyword.count, keyword.starts(with: previousSearchWord) {
                search(filterationBooks: filterBooks.flatMap { $0 }, keyword: keyword)
            }
        }
        search(filterationBooks: books, keyword: keyword)
    }
    
    func search(filterationBooks: [Book], keyword: String) {
        self.state.value = .searchingBooks(message: "Searching Books...")
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            var titleBooks: [Book] = [], publisherBooks: [Book] = [], descriptionBooks: [Book] = []
            filterationBooks.forEach { (book) in
                if book.title.localizedCaseInsensitiveContains(keyword) {
                    titleBooks.append(book)
                } else if book.publisher.localizedCaseInsensitiveContains(keyword) {
                    publisherBooks.append(book)
                } else if book.description.localizedCaseInsensitiveContains(keyword) {
                    descriptionBooks.append(book)
                }
            }
            
            DispatchQueue.main.async {
                self?.state.value = .search(books:[titleBooks, publisherBooks, descriptionBooks])
                self?.previousSearchWord = keyword
            }
        }
    }
    
    func exitSearch() {
        self.previousSearchWord = nil
        state.value = .displayBooks(books: books)
    }
}

// MARK: TableView endpoints
extension BookViewModel {
    func sectionCountForState() -> Int {
        if case .displayBooks = state.value {
            return 1
        } else if case .search(let books) = state.value {
            return books.count
        }
        return 0
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if case .displayBooks(let books) = state.value {
            return books.count
        } else if case .search(let books) = state.value {
            return books[section].count
        }
        return 0
    }
    
    func book(for indexPath: IndexPath) -> Book? {
        if case .displayBooks(let books) = state.value {
            return books[indexPath.row]
        } else if case .search(let books) = state.value {
            return books[indexPath.section][indexPath.row]
        }
        return nil
    }
    
    func sectionTitle(for section: Int) -> String? {
        if case .search(let books) = state.value {
            var sectionsTitles = ["Title", "Publisher", "Description"]
            if books[section].count > 0 {
                return "Found in " + sectionsTitles[section]
            }
        }
        return nil
    }
}
