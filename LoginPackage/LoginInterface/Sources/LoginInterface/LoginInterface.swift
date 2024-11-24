// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol LoginInterface{
    func moveToLanding(navigationController: UINavigationController?)
    func moveToLogin(navigationController: UINavigationController?)
    func loginSuccess()
}
