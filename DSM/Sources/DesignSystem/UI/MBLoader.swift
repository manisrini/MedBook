//
//  M.swift
//  DesignSystem
//
//  Created by Manikandan on 23/11/24.
//
import SVProgressHUD

@MainActor
public class MBLoader{
    
    public class func show() {
        SVProgressHUD.setBackgroundColor(.darkGray)
        SVProgressHUD.setForegroundColor(.cyan)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }

    public class func hide()
    {
        SVProgressHUD.dismiss()
    }
}
