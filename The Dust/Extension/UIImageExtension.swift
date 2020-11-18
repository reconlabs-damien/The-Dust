//
//  UIImageExtension.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import Foundation
import UIKit

extension UIImage {
    
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
