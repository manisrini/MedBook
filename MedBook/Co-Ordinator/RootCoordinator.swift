//
//  Untitled.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//

import UIKit
import Login
import Utilities
import LoginInterface
import DataBase
import Home

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


class MainCoordinator: @preconcurrency Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor func start() {
        
        let dbManager = DatabaseManager.shared
        if UserDataHelper.isUserLoggedIn(dbManager: dbManager){
            let homeGateway = HomeGateway()
            homeGateway.moveToHome(isInitialView: true, navigationController: navigationController)
        }else{
            let loginGateway = LoginGateway()
            loginGateway.moveToLanding(navigationController: navigationController)
        }
    }
}
