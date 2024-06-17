//
//  CommandBase.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import UIKit

public class CommandBase: NSObject {
    
    public static let sharedInstance = CommandBase()

    // MARK: - UIApplication Open URL
    
    /// 開啟指定的 URL
    /// - Parameters:
    ///   - url: URL 字串
    public func openURL(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url) { _ in }
    }
}
