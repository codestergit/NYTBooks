//
//  BookViewModelable.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import Foundation

protocol ViewModelable : CustomStringConvertible {}

extension ViewModelable {
    var description: String {
        return "\(type(of: self))"
    }
}


protocol BookViewModelable: ViewModelable {
    var state: Observer<BookViewModel.UIState> { get }
    func changeDate(date: Date)
    
    func exitSearch()
    func search(keyword: String)

    
    func numberOfRowsInSection(section: Int) -> Int
    func book(for indexPath: IndexPath) -> Book?
    func sectionCountForState() -> Int
    func sectionTitle(for section: Int) -> String?
}
