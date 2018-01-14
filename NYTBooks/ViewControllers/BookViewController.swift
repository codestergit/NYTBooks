//
//  ViewController.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeDate: UIBarButtonItem!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblMessage: UILabel!
    
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Books"
        controller.searchBar.delegate = self
        controller.searchBar.tintColor = UIColor.white
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    private var viewModel: BookViewModel! = nil {
        didSet {
            bindValues()
        }
    }
    
}

// MARK: methods
extension BookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        viewModel = BookViewModel()
    }
    
    private func setupUI() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.layer.backgroundColor = UIColor.white.cgColor
            textfield.layer.cornerRadius = 10.0
            textfield.layer.masksToBounds = true
            textfield.tintColor = UIColor.black
            textfield.backgroundColor = UIColor.white
        }
    }
    
    private func bindValues() {
        guard let viewModel = viewModel, isViewLoaded else {
            return
        }
        viewModel.state.bindAndFire { [unowned self] (state) in
            self.refreshData(state: state)
        }
    }
    
    @IBAction func changeDate(_ sender: UIBarButtonItem) {
        let datePicker = DatePickerView.showOn(view: self.view, animated: true)
        datePicker.delegate = self
        changeDate.isEnabled = false
    }
    
    
    private func refreshData(state: BookViewModel.UIState) {
        hideMessage()
        switch state {
        case .displayBooks, .search:
            tableView.reloadData()
        case .loading(let message):
            showMessage(message: message, indicatorAnimation: true)
        case .nobooks(let error):
            showMessage(message: error.errorDescription ?? "")
        case .searchingBooks(let message):
            showMessage(message: message)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: Search Functionality
extension BookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            viewModel?.exitSearch()
            return
        }
        viewModel.search(keyword: searchText)
    }
}

extension BookViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.exitSearch()
    }
}

// MARK: TableViewDatasource
extension BookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sectionCountForState() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            fatalError("Not a book cell!!")
        }
        guard let book = viewModel?.book(for: indexPath) else {
            fatalError("Book not found for the indexpath!!")
        }
        cell.setupBookCell(book: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sectionTitle(for: section)
    }
}

// MARK: Error Message Handling
extension BookViewController {
    func showMessage(message: String, indicatorAnimation: Bool = false) {
        self.messageView.isHidden = false
        self.view.bringSubview(toFront: self.messageView)
        if indicatorAnimation {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        self.lblMessage.text = message
    }
    
    func hideMessage() {
        self.messageView.isHidden = true
        self.activityIndicator.isHidden = true
        self.view.sendSubview(toBack: self.messageView)
    }
}

// MARK: DatePicker Delegates
extension BookViewController: DatePickerViewDelegate {
    func dateDidSelected(date: Date) {
        changeDate.isEnabled = true
        viewModel.changeDate(date: date)
    }
    
    func dateSelectionCancel() {
        changeDate.isEnabled = true
    }
}

