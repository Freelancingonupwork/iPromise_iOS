//
//  UIImage+Extension.swift
//  iPromise
//
//  Created by Apple on 17/03/23.
//

import UIKit
import SDWebImage

extension UIImage {

    /// This method creates an image of a view
    convenience init?(view: UIView) {

        // Based on https://stackoverflow.com/a/41288197/1118398
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}


extension UIImageView{
    func setImageFromUrl(url : String){
        
        self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "imagePlaceholder"))
    }
}
