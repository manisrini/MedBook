//
//  HomeScreenVC.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

import UIKit
import SwiftUI
import DesignSystem
import SnapKit
import Utilities

final class HomeScreenVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var sortContainerView: UIView!
    
    var viewModel = HomeScreenViewModel()
    var dataManager = HomeScreenDataManager()
    weak var coordinator : MainCoordinator?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup(){
        self.setupNavBar()
        self.setupSearchBar()
        self.setUpTableView()
        self.setUpSortingView()
                
        
        if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                    print("Core Data Path : Documents Directory: \(directoryLocation)Application Support")
         }
        
    }
    
    private func setupNavBar(){
        
        let titleLabel = UILabel()
        titleLabel.text = "MedBook"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let logoImageView = UIImageView(image: UIImage(systemName: "book.closed"))
        logoImageView.tintColor = .black
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let titleStackView = UIStackView(arrangedSubviews: [logoImageView, titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        
        let customTitleView = UIView()
        customTitleView.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints { make in
            make.left.equalTo(customTitleView)
            make.centerY.equalTo(customTitleView)
        }
        //Right bar buttons
        let bookMarkButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapBookMark)
        )
        bookMarkButton.tintColor = .black
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.square.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        logoutButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customTitleView)
        navigationItem.rightBarButtonItems = [logoutButton,bookMarkButton]
    }
    
    
    @objc func didTapBookMark(){
        coordinator?.showBookMarks(dataManager: dataManager)
    }
    
    @objc func didTapLogout(){
        
    }
    
    private func setUpTableView(){
        self.booksTableView.delegate = self
        self.booksTableView.dataSource = self
        self.booksTableView.register(UINib(nibName: BookDetailCell.nibName, bundle: nil), forCellReuseIdentifier: BookDetailCell.nibName)
    }
    
    @objc func loadMoreData(){
        self.viewModel.fetchBooks(dataManager: dataManager) { [weak self] books,error in
            if error == nil && books.count > 0{
                
                DispatchQueue.main.async {
                    self?.booksTableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func setupSearchBar(){
        self.searchBar.placeholder = "Search for books"
        self.searchBar.delegate = self
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            textfield.backgroundColor = UIColor.gray
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }

        }
    }
    
    private func setUpSortingView(){
        
        let sortingHostingView = UIHostingController(rootView: SortingOptionsView(didTapBtn: { [weak self] selectedOption in
            self?.viewModel.sortBooks(using: selectedOption.type)
            self?.booksTableView.reloadData()
            
        }))
        sortContainerView.addSubview(sortingHostingView.view)
        
        sortingHostingView.view.snp.makeConstraints { make in
            make.left.equalTo(sortContainerView).inset(10)
            make.right.equalTo(sortContainerView).offset(10)
            make.top.equalTo(sortContainerView)
            make.bottom.equalTo(sortContainerView)
        }
        
        sortContainerView.isHidden = true //hidden in initial state since no characters are typed
    }
    
    
    
    private func insertNewDataIntoTableView(_ newBooks: [MedBook]) {
//        let currentRowCount = self.viewModel.currentLastRow + 1
//        let newIndexPaths = (currentRowCount..<viewModel.medBooks.count).map {
//            IndexPath(row: $0, section: 0)
//        }
//        self.booksTableView.insertRows(at: newIndexPaths, with: .automatic)
        self.booksTableView.reloadData()
    }

      
}

extension HomeScreenVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: BookDetailCell.nibName, for: indexPath) as? BookDetailCell{
            
            bookCell.contentConfiguration = UIHostingConfiguration{
                BookDetailCellView(book: self.viewModel.medBooks[indexPath.row])
            }
            return bookCell
        }
        
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
    
    
//    Pagination functionality
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.medBooks.count - 1{
            TableViewUtils.shared.showSpinnerInBottom(tableView: tableView)
            self.loadMoreData()
        }else{
            TableViewUtils.shared.hideSpinnerInBottom(tableView: tableView)
        }
    }
    
    //For bookmark functionality
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isBookmarked = self.viewModel.medBooks[indexPath.row].isBookMarked
        
        let item = UIContextualAction(style: .destructive, title: isBookmarked ? "UnBookMark" : "BookMark") { [weak self] (_, _, completionHandler) in
            self?.updateBookMarkStatus(indexPath: indexPath)
            completionHandler(true)
        }
        item.image = UIImage(systemName: "heart.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    
    
    private func updateBookMarkStatus(indexPath : IndexPath){
        self.viewModel.saveBookMarkStatus(for: indexPath.row,dataManager: dataManager)
        booksTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension HomeScreenVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.searchText = searchText
        if searchText.count >= 3{

            MBLoader.show()
            
            viewModel.fetchBooks(dataManager: dataManager) {[weak self] allBooks,error in
                if let _self = self{
                    
                    DispatchQueue.main.async {
                        MBLoader.hide()
                        _self.sortContainerView.isHidden = false
                        _self.booksTableView.reloadData()
                    }
                }
            }
        }else{
            self.booksTableView.reloadData()
            self.sortContainerView.isHidden = true
        }
    }
}
