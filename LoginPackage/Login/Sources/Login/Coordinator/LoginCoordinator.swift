//
//  LoginCoordinator.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import UIKit
import Utilities
import DependencyContainer
import HomeInterface

final class LoginCoordinator{
    private weak var navigationController : UINavigationController?
    
    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor
    public func moveToLanding(){
        if let landingVC = LandingVC.instantiate(bundle: .module) as? LandingVC{
            landingVC.coordinator = self
            self.navigationController?.pushViewController(landingVC, animated: true)
        }
    }
    
    @MainActor
    public func moveToLogin(){
        if let loginVC = LoginVC.instantiate(bundle: .module) as? LoginVC{
            loginVC.coordinator = self
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @MainActor
    func moveToSignUp(){
        if let signUpVC = SignUpVC.instantiate(bundle: .module) as? SignUpVC{
            signUpVC.coordinator = self
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    
    @MainActor //Login or Signup success
    func moveToHomeScreen(){
        let gateway = DC.shared.resolve(type: .closureBased, for: HomeInterface.self)
        gateway.moveToHome(isInitialView: false, navigationController: navigationController)

    }
}
