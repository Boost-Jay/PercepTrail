//
//  Alert+AddMultipleActions.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import UIKit

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach { action in
            self.addAction(action)
        }
    }
}
