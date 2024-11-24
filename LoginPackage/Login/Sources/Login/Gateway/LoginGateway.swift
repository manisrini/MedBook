//
//  File.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import Foundation
import LoginInterface
import UIKit


public struct LoginGateway : @preconcurrency LoginInterface{
    
    public init() {}
    
    @MainActor
    public func moveToLanding(navigationController: UINavigationController?){
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.moveToLanding()
    }
    
    @MainActor
    public func moveToLogin(navigationController: UINavigationController?){
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.moveToLogin()
    }
    
    
    public func loginSuccess() {
        print("LoginSuccess")
    }

    
}
