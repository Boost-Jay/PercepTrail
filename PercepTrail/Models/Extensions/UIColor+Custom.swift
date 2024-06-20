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
