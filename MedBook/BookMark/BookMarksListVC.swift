//
//  BookMarksLIstVC.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//
import UIKit
import SwiftUI

class BookMarksListVC : UIViewController{
    
    @IBOutlet weak var booksMarksTableView: UITableView!
    
    var viewModel : BookMarksListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BookMarks"
        self.setUpTableView()
        self.fetchBookMarks()
    }
    
    private func setUpTableView(){
        self.booksMarksTableView.delegate = self
        self.booksMarksTableView.dataSource = self
        self.booksMarksTableView.register(UINib(nibName: BookDetailCell.nibName, bundle: nil), forCellReuseIdentifier: BookDetailCell.nibName)
    }
    
    func config(for viewModel : BookMarksListViewModel){
        self.viewModel = viewModel
        self.fetchBookMarks()
    }
    
    private func fetchBookMarks(){
        self.viewModel.fetchBookMarks()
        self.booksMarksTableView.reloadData()
    }
    
    
}

extension BookMarksListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: BookDetailCell.nibName, for: indexPath) as? BookDetailCell{
            
            bookCell.contentConfiguration = UIHostingConfiguration{
                BookDetailCellView(book: self.viewModel.bookMarks[indexPath.row])
            }
            return bookCell
        }
        
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookMarks.count
    }
    
    
    //For bookmark functionality
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "UnBookMark") { [weak self] (_, _, completionHandler) in
            self?.updateBookMarkStatus(indexPath: indexPath)
            completionHandler(true)
        }
        item.image = UIImage(systemName: "heart.bookmark")
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    
    
    private func updateBookMarkStatus(indexPath : IndexPath){
        let bookMarkToDelete = self.viewModel.bookMarks[indexPath.row]
        self.viewModel.bookMarks.remove(at: indexPath.row)
        booksMarksTableView.deleteRows(at: [indexPath], with: .automatic)
        self.viewModel.removeBookMarkFromDB(for: bookMarkToDelete.id)
    }
}

