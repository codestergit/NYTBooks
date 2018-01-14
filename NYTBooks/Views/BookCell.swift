//
//  BookCell.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPublisher: UILabel!
}

extension BookCell {
    func setupBookCell(book: Book, keyword: String? = nil) {
        self.lblTitle.text = book.title
        self.lblPublisher.text = (book.publisher.count > 0) ? "By " + book.publisher : ""
        self.lblDescription.text = (book.description.count > 0) ? book.description : "No Description."
    }
}

