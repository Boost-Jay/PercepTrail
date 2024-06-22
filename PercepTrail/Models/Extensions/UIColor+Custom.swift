//
//  UIColor+Custom.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import UIKit

extension UIColor {
    
    /// 將 Hex 的顏色表達，轉成 RGB 的 UIColor
    /// - Parameters:
    ///   - rgbValue: Hex 的顏色表達
    ///   - alpha: 透明度，預設為 1.0
    /// - Returns: 轉成 RGB 的 UIColor
    static func fromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    
    /// 主頁面 button color
    static let TakePhotoColor = UIColor.fromHex(rgbValue: 0x7FA884)
    static let SiteVisitColor = UIColor.fromHex(rgbValue: 0xDCBCC3)
    static let QuickQuizColor = UIColor.fromHex(rgbValue: 0xF0E5E1)
    static let GroupTaskColor = UIColor.fromHex(rgbValue: 0xD6D6D6)
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt64 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt64(&hexInt)

        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
