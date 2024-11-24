//
//  Untitled.swift
//  Home
//
//  Created by Manikandan on 24/11/24.
//



import Foundation
import HomeInterface
import UIKit

public struct HomeGateway : @preconcurrency HomeInterface{
    
    public init() {}
    
    @MainActor
    public func moveToBookMarks(navigationController: UINavigationController?) {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.moveToBookMarks()
    }
        
    @MainActor
    public func moveToHome(isInitialView : Bool,navigationController: UINavigationController?) {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.moveToHomeScreen(isInitialView: isInitialView)
    }

}
