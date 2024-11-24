//
//  LoginVC.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//
import UIKit
import SwiftUI
import SnapKit
import Utilities
import DesignSystem


final public class LandingVC : UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    
    var coordinator : LoginCoordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utilities.hexStringToUIColor(hex: DSMColorTokens.AppTheme.rawValue)
        self.setupView()
    }
    
    private func setupView(){
        let landingView = LandingView(didTapLogin: {
            self.coordinator?.moveToLogin()
        },didTapSignup: {
            self.coordinator?.moveToSignUp()
        })
        
        let hostingLandingView = UIHostingController(rootView: landingView)
        self.containerView.addSubview(hostingLandingView.view)
        
        hostingLandingView.view.snp.makeConstraints { make in
            make.left.equalTo(self.containerView)
            make.right.equalTo(self.containerView)
            make.top.equalTo(self.containerView)
            make.bottom.equalTo(self.containerView)
        }
    }
    
}
