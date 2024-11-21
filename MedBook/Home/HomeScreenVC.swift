//
//  HomeScreenVC.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

import UIKit
import SwiftUI

class HomeScreenVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTableView: UITableView!
    
    var viewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup(){
        self.title = "Star Wars Blaster Tournament"
        self.setupSearchBar()
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
    
    
    private func fetchData(){
//        viewModel.fetchPlayersData { [weak self] success in
//            DispatchQueue.main.async {
//                self?.pointsTableView.reloadData()
//            }
//        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.medBooks.count
    }
        
}


extension HomeScreenVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count >= 3{
            viewModel.fetchBooks { response , error in
                DispatchQueue.main.async {
                    self.booksTableView.reloadData()
                }
            }
        }
    }
}
