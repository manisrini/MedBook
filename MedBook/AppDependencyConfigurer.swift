//
//  AppDependencyConfigurer.swift
//  MedBook
//
//  Created by Manikandan on 24/11/24.
//

import HomeInterface
import Home
import Login
import LoginInterface
import DependencyContainer

@MainActor
enum AppDependencyConfigurer {
    static func configure() {
        // MARK: - Home Registration
        let homeScreenClosure: () -> HomeInterface = {
            HomeGateway()
        }
        DC.shared.register(type: .closureBased(homeScreenClosure), for: HomeInterface.self)

        // MARK: - Login  Registration
        let loginScreenClosure: () -> LoginInterface = {
            LoginGateway()
        }
        DC.shared.register(type: .closureBased(loginScreenClosure), for: LoginInterface.self)
    }
}
