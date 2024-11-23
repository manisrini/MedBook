//
//  LoginVC.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import UIKit
import SwiftUI

class LoginVC : UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView(){
        
        let hostingLoginVC = UIHostingController(rootView: LoginView(didTapSignUp: {
            
        }))
        self.containerView.addSubview(hostingLoginVC.view)
    }
}
