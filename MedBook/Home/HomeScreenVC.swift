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

class HomeScreenVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var sortContainerView: UIView!
    
    var viewModel = HomeScreenViewModel()
    var loader = MBActivityIndicator()
    var dataManager = HomeScreenDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup(){
        self.title = "Star Wars Blaster Tournament"
        self.setupSearchBar()
        self.setUpTableView()
        self.setUpSortingView()
        
        self.loader.center = self.booksTableView.center
        self.booksTableView.addSubview(loader)
        
        
        if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                    print("Core Data Path : Documents Directory: \(directoryLocation)Application Support")
         }
    }
    
    private func setUpTableView(){
        self.booksTableView.delegate = self
        self.booksTableView.dataSource = self
        self.booksTableView.register(UINib(nibName: BookDetailCell.nibName, bundle: nil), forCellReuseIdentifier: BookDetailCell.nibName)
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
        return self.viewModel.medBooks.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "Bookmark") {  (contextualAction, view, boolValue) in

        }
        item.image = UIImage(systemName: "heart.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
}

extension HomeScreenVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.searchText = searchText
        if searchText.count >= 3{
            loader.show()
            viewModel.fetchBooks(dataManager: dataManager) {[weak self] response , error in
                if let _self = self{
                    DispatchQueue.main.async {
                        _self.sortContainerView.isHidden = false
                        _self.loader.hide()
                        _self.booksTableView.reloadData()
                    }
                }
            }
        }else{
            self.sortContainerView.isHidden = true
        }
    }
}
