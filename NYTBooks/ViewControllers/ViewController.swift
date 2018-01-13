//
//  ViewController.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NYTBookService.requestBooks(publishDate: "2018-01-13").fetchBooks().bindAndFire { (responseStatus) in
            switch responseStatus {
            case .loading:
                print("Loading")
            case .success(let value):
                print(value.getAllBooks())
            case .failure(let error):
                print(error)
                //Handle Errors
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

