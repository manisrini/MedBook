// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit


extension String{
    
    public func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

extension Double{
    public func formatDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

@MainActor
public class TableViewUtils{
    
    public static let shared = TableViewUtils()
    var spinner = UIActivityIndicatorView(style: .medium)
    
    public func showSpinnerInBottom(tableView : UITableView){
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    public func hideSpinnerInBottom(tableView : UITableView){
        spinner.stopAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(0), height: CGFloat(0))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }
}

