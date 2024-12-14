//
//  HomeCoordinator.swift
//  Home
//
//  Created by Manikandan on 24/11/24.
//

import UIKit
import DependencyContainer
import LoginInterface
import DataBase

final class HomeCoordinator{
    private weak var navigationController : UINavigationController?
    var homeScreenVC : HomeScreenVC?
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor
    public func moveToHomeScreen(isInitialView : Bool = false){
        if let homeScreen = HomeScreenVC.instantiate(bundle: .module) as? HomeScreenVC{
            self.homeScreenVC = homeScreen
            homeScreen.coordinator = self
            homeScreen.isInitialView = isInitialView
            self.navigationController?.pushViewController(homeScreen, animated: true)
        }
    }
    
    @MainActor
    public func moveToBookMarks(){
        if let bookMarksListVC = BookMarksListVC.instantiate(bundle: .module) as? BookMarksListVC{
            bookMarksListVC.coordinator = self
            self.navigationController?.pushViewController(bookMarksListVC, animated: true)
        }
    }
    
    @MainActor
    public func moveToDetailView(book : MedBook){
        if let bookDetailVC = BookDetailVC.instantiate(bundle: .module) as? BookDetailVC{
            bookDetailVC.book = book
            self.navigationController?.pushViewController(bookDetailVC, animated: true)
        }
    }
    
    @MainActor
    public func logoutUser(isInitialView : Bool){
        if isInitialView{
            let loginGateway = DC.shared.resolve(type: .closureBased, for: LoginInterface.self)
            loginGateway.moveToLanding(navigationController: navigationController)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}

