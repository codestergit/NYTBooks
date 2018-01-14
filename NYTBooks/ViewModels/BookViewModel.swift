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
        case nobooks(error: UIError) // Change it to enum
        case loading(message: String)
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
    
    func fetchBooks(for date: Date) {
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

extension BookViewModel {
    func changeDate(date: Date) {
        fetchBooks(for: date)
    }
}


extension BookViewModel {
    func numberOfRowsInSection(section: Int) -> Int {
         return books.count
    }
    
    func book(for indexPath: IndexPath) -> Book? {
        return books[indexPath.row]
    }
}

