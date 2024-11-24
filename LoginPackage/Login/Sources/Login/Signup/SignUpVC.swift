//
//  SignUpVC.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import UIKit
import SwiftUI
import DesignSystem
import Utilities
import CryptoKit


class SignUpVC : UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    weak var coordinator : LoginCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utilities.hexStringToUIColor(hex: DSMColorTokens.AppTheme.rawValue)
        self.setupView()
    }
    
    private func setupView(){
        let signUpView = SignUpView { [weak self] in
            //On signup Tap
            self?.coordinator?.moveToHomeScreen()
        }
        
        let hostingSignUpVC = UIHostingController(rootView: signUpView)
        self.containerView.addSubview(hostingSignUpVC.view)
        
        hostingSignUpVC.view.snp.makeConstraints { make in
            make.left.equalTo(self.containerView)
            make.right.equalTo(self.containerView)
            make.top.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
        }
    }
    

}
