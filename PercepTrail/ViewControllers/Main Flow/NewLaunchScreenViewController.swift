//
//  NewLaunchScreenViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/20/24.
//

import UIKit

class NewLaunchScreenViewController: UIViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performAutoSegue()
    }
    
    // MARK: - Function
    
    private func performAutoSegue() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.performSegue(withIdentifier: "showMainPage", sender: self)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "NewLaunchScreenViewController")
}
