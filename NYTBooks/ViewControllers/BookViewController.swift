//
//  ViewController.swift
//  NYTBooks
//
//  Created by Wasan, Sahil on 13/01/18.
//  Copyright © 2018 Wasan, Sahil. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeDate: UIBarButtonItem!
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Books"
        controller.searchBar.delegate = self
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    private var viewModel: BookViewModel! = nil {
        didSet {
            bindValues()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        viewModel = BookViewModel()
    }
    
    func setupUI() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func bindValues() {
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

    
    func refreshData(state: BookViewModel.UIState) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


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

extension BookViewController: DatePickerViewDelegate {
    func dateDidSelected(date: Date) {
        changeDate.isEnabled = true
        viewModel.changeDate(date: date)
    }
    
    func dateSelectionCancel() {
        changeDate.isEnabled = true
    }
}
