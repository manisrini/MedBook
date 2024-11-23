//
//  Untitled.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//

import UIKit
import Login

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeScreen = HomeScreenVC.instantiate()
        homeScreen.coordinator = self
        navigationController.pushViewController(homeScreen, animated: false)
    }
    
    func showBookMarks(dataManager : HomeScreenDataManager) {
        let booksMarksScreen = BookMarksListVC.instantiate()
        booksMarksScreen.viewModel = BookMarksListViewModel(dataManager: dataManager)
        navigationController.pushViewController(booksMarksScreen, animated: true)
    }
}

extension UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: className, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
