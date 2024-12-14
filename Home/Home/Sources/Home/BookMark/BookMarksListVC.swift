//
//  BookMarksLIstVC.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//
import UIKit
import SwiftUI
import DataBase
import Utilities


class BookMarksListVC : UIViewController{
    
    @IBOutlet weak var booksMarksTableView: UITableView!
    
    var viewModel = BookMarksListViewModel()
    var coordinator : HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BookMarks"
        self.setUpTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    private func setUpTableView(){
        self.booksMarksTableView.delegate = self
        self.booksMarksTableView.dataSource = self
        self.booksMarksTableView.register(UINib(nibName: BookDetailCell.nibName, bundle: .module), forCellReuseIdentifier: BookDetailCell.nibName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchBookMarks()
    }
        
    private func fetchBookMarks(){
        self.viewModel.fetchBookMarks{ [weak self] in
            DispatchQueue.main.async {
                self?.booksMarksTableView.reloadData()
            }
        }
    }
    
    
}

extension BookMarksListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: BookDetailCell.nibName, for: indexPath) as? BookDetailCell{
            
            let book =  self.viewModel.bookMarks[indexPath.row]
            bookCell.contentConfiguration = UIHostingConfiguration{
                BookDetailCellView(
                    book: MedBook(
                        title: book.title ?? "",
                        ratings_average: book.ratings_avg,
                        ratings_count: Int(book.ratings_count),
                        author_name: book.author_name ?? "",
                        imageUrl: book.imageUrl,
                        cover_edition_key: book.cover_edition_key ?? "",
                        isBookMarked: true
                    )
                )
            }
            return bookCell
        }
        
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.bookMarks.count == 0{
            TableViewUtils.shared.setEmptyMessageText("No BookMarks found", textColor: UIColor.black, tableView: tableView)
        }else{
            TableViewUtils.shared.setEmptyMessageText("", textColor: .clear, tableView: tableView)

        }
        
        return self.viewModel.bookMarks.count
    }
    
    
    //For bookmark functionality
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "UnBookMark") { [weak self] (_, _, completionHandler) in
            self?.updateBookMarkStatus(indexPath: indexPath)
            completionHandler(true)
        }
        item.image = UIImage(systemName: "bookmark.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.viewModel.bookMarks[indexPath.row]
        
        coordinator?.moveToDetailView(
            book: MedBook(
                id : book.id ?? UUID(),
                title: book.title ?? defaultStr,
                ratings_average: book.ratings_avg,
                ratings_count: Int(book.ratings_count),
                author_name: book.author_name ?? defaultStr,
                imageUrl: book.imageUrl,
                cover_edition_key: book.cover_edition_key ?? defaultStr,
                isBookMarked: true
            )
        )
    }
    
    private func updateBookMarkStatus(indexPath : IndexPath){
        let bookMarkToDelete = self.viewModel.bookMarks[indexPath.row]
        
        guard let bookMarkId = bookMarkToDelete.id else {return }
        self.viewModel.removeBookMarkFromDB(for: bookMarkId ) { [weak self] success in
            if success{
                DispatchQueue.main.async {
                    self?.viewModel.bookMarks.remove(at: indexPath.row)
                    self?.booksMarksTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
                //To refresh the home page List
                NotificationCenter.default.post(name: NSNotification.Name("BookMarkRemove"), object: bookMarkId)
            }
        }
    }
}

