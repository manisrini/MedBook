//
//  SwiftUIView.swift
//  
//
//  Created by Manikandan on 21/09/24.
//

import UIKit
import SDWebImage
import SwiftUI

public class CustomImage : UIImageView{
        
    public func loadImage(url : String){
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageTransition = .flipFromTop
        
        if let url = URL(string: url){
            let placeholderImage = UIImage(named: "thumbnail",in: .module,compatibleWith: nil)
            self.sd_setImage(with: url) { image, error, type, url in
                if error != nil{
                    self.image = placeholderImage
                }
            }
        }
        
    }
}


public struct CustomImageView: UIViewRepresentable {
    let url: String
    
    public init(url: String) {
        self.url = url
    }

    public func makeUIView(context: Context) -> CustomImage {
        let imageView = CustomImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }

    public func updateUIView(_ uiView: CustomImage, context: Context) {
        uiView.loadImage(url: url)
    }
}
