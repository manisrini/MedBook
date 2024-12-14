//
//  BooksDetailVC.swift
//  Home
//
//  Created by Manikandan on 12/12/24.
//

import UIKit
import SwiftUI
import DataBase


class BookDetailVC : UIViewController{
    
    
    @IBOutlet weak var containerView: UIView!
    var book : MedBook?
    var dataManager : HomeScreenDataHelper?
    var viewModel : BookDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.initialSetup()
    }
    
    private func setupNavBar(){
        
        let imageName = book?.isBookMarked ?? false ? "bookmark.fill" : "bookmark"
        
        let bookMarkButton = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(didTapBookMark)
        )
        bookMarkButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [bookMarkButton]

    }
    
    @objc func didTapBookMark(){
        let isBookMarked = book?.isBookMarked ?? false

        book?.isBookMarked.toggle()
        self.setupNavBar()

        if isBookMarked{
            guard let bookMarkId = book?.id else {return }
            self.viewModel?.removeBookMarkFromDB(for: bookMarkId){ [weak self] in
                self?.showAlert(isAdded: false)
            }
            NotificationCenter.default.post(name: NSNotification.Name("BookMarkRemove"), object: bookMarkId)
            
        }else{
            self.viewModel?.saveBookMarkStatus{ [weak self] in
                self?.showAlert(isAdded: true)
            }
            NotificationCenter.default.post(name: NSNotification.Name("BookMarkRemove"), object: book)
        }
    }
    
    
    private func showAlert(isAdded : Bool){
        let alert = UIAlertController(title: "Bookmark", message: isAdded ? "Added Successfully" : "Removed Successfully", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    func initialSetup(){
        
        guard let book = book else{
            return
        }
        let vm = BookDetailViewModel(medBook: book)
        self.viewModel = vm
        let detailView = BookDetailView(viewModel: vm)
        
        let hostingDetailVC = UIHostingController(rootView: detailView)
        self.containerView.addSubview(hostingDetailVC.view)
        
        hostingDetailVC.view.snp.makeConstraints { make in
            make.left.equalTo(self.containerView)
            make.right.equalTo(self.containerView)
            make.top.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
        }
    }
    
    
}
