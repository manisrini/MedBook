// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol HomeInterface{
    func moveToHome(isInitialView: Bool,navigationController: UINavigationController?)
    func moveToBookMarks(navigationController: UINavigationController?)
}
