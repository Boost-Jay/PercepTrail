//
//  Alert.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

//
//  Alert.swift
//  gin-frontend
//
//  Created by 王柏崴 on 3/2/24.
//

import UIKit

// MARK: - Alert

@MainActor
struct Alert {
    private static func presentAlert(on vc: UIViewController, alertController: UIAlertController) {
        vc.present(alertController, animated: true)
    }
    
    private static func addAction(to alertController: UIAlertController, title: String, style: UIAlertAction.Style, handler: (() -> Void)?) {
        let action = UIAlertAction(title: title, style: style) { _ in handler?() }
        alertController.addAction(action)
    }
    
    static func showAlertWithError(title: String,
                                   message: String,
                                   vc: UIViewController,
                                   confirmTitle: String,
                                   confirm: (() -> Void)? = nil) {
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        addAction(to: alertVC,
                  title: confirmTitle,
                  style: .default,
                  handler: confirm)
        presentAlert(on: vc, alertController: alertVC)
    }
    
    static func showAlertWithAction(title: String,
                                    message: String,
                                    vc: UIViewController,
                                    confirmTitle: String,
                                    cancelTitle: String,
                                    confirm: (() -> Void)? = nil,
                                    cancel: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        addAction(to: alertVC,
                  title: confirmTitle,
                  style: .default,
                  handler: confirm)
        addAction(to: alertVC,
                  title: cancelTitle,
                  style: .cancel,
                  handler: cancel)
        presentAlert(on: vc, alertController: alertVC)
    }
    
    static func showAlertWithTextFields(title: String,
                                        message: String,
                                        vc: UIViewController,
                                        confirmTitle: String,
                                        cancelTitle: String,
                                        numberOfTextFields: Int,
                                        configureTextFields: @escaping ([UITextField]) -> Void,
                                        confirm: @escaping ([UITextField]) -> Void,
                                        cancel: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for _ in 0 ..< numberOfTextFields {
            alertVC.addTextField { _ in
                // textField 的配置在這裡添加
            }
        }

        // 設置 text fields 的外觀和功能
        if let textFields = alertVC.textFields {
            configureTextFields(textFields)
        }

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            if let textFields = alertVC.textFields {
                confirm(textFields)
            }
        }

        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancel?()
        }
        alertVC.addActions(confirmAction, cancelAction)

        vc.present(alertVC, animated: true, completion: nil)
    }
    
    static func showActionSheetWith(title: String,
                                    message: String,
                                    options: [String],
                                    vc: UIViewController,
                                    cancelTitle: String,
                                    confirm: @escaping (Int) -> Void,
                                    cancel: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .actionSheet)
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { _ in
                let index = options.firstIndex(of: option) ?? 0
                confirm(index)
            }
            alertVC.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancel?()
        }
        alertVC.addAction(cancelAction)
        
        vc.present(alertVC, animated: true)
    }
}

extension Alert {
    struct MenuAction {
        let title: String
        let action: () -> Void
    }
    
    /// 修改 makeContextMenu 來接受可變參數的 MenuAction
    static func makeContextMenu(actions: MenuAction...) -> UIMenu {
        // 使用 actions 參數來建立 UIAction 陣列
        let menuActions = actions.map { menuAction in
            UIAction(title: menuAction.title, handler: { _ in
                menuAction.action()
            })
        }
        return UIMenu(title: "", children: menuActions)
    }
}

extension Alert {
    
    /// enum Toast 顯示時長
    enum ToastDisplayInterval {
        
        /// 顯示 Toast 1.5 秒後，移除 Toast
        case short
        
        /// 顯示 Toast 3 秒後，移除 Toast
        case long
        
        /// 自定義要顯示 Toast 幾秒後，移除 Toast
        case custom(Double)
    }
    
    /// 用 UIAlertController 顯示 Toast
    /// - Parameters:
    ///   - message: 要顯示在 Toast 上的訊息
    ///   - vc: 要在哪個畫面跳出來
    ///   - during: Toast 要顯示多久
    ///   - present: Toast 顯示出來後要做的事，預設為 nil
    ///   - dismiss: Toast 顯示消失後要做的事，預設為 nil
    static func showToastWith(message: String?,
                              vc: UIViewController,
                              during: ToastDisplayInterval,
                              present: (() -> Void)? = nil,
                              dismiss: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil,
                                                    message: message,
                                                    preferredStyle: .alert)
            vc.present(alertController, animated: true, completion: present)
            
            switch during {
            case .short:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    vc.dismiss(animated: true, completion: dismiss)
                }

            case .long:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    vc.dismiss(animated: true, completion: dismiss)
                }

            case .custom(let interval):
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    vc.dismiss(animated: true, completion: dismiss)
                }
            }
        }
    }
}
