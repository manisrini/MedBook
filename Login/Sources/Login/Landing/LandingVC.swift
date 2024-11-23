//
//  LoginVC.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//
import UIKit
import SwiftUI

public protocol LoginProtocol{
    func onLoginSucces()
}

final public class LandingVC : UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "MedBook"
        
        self.setupView()
    }
    
    
    private func setupView(){
        let hostingLandingView = UIHostingController(rootView: LandingView())
        self.containerView.addSubview(hostingLandingView.view)
        
        
    }
    
}
