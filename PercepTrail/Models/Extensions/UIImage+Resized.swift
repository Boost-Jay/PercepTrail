//
//  UIImage+Resized.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/22.
//

import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
