//
//  LoginVC.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import UIKit
import SwiftUI
import SnapKit
import DesignSystem
import Utilities


class LoginVC : UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    var coordinator : LoginCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utilities.hexStringToUIColor(hex: DSMColorTokens.AppTheme.rawValue)
        self.setupView()
    }
    
    private func setupView(){
        
        let loginView = LoginView { [weak self] in
            //On login Tap
            print("login tap")
            self?.coordinator?.moveToHomeScreen()
        }
        
        let hostingLoginVC = UIHostingController(rootView: loginView)
        self.containerView.addSubview(hostingLoginVC.view)
        
        hostingLoginVC.view.snp.makeConstraints { make in
            make.left.equalTo(self.containerView)
            make.right.equalTo(self.containerView)
            make.top.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
        }
    }
}
