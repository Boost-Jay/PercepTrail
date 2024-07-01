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
                
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.performAutoSegue(self)
        }
    }
    
    // MARK: - Function
    
    func performAutoSegue(_ sender: Any) {
        if UserPreferences.shared.finishInit {
            performSegue(withIdentifier: "pushMain", sender: nil)
        } else {
            performSegue(withIdentifier: "showExercisePage", sender: nil)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "NewLaunchScreenViewController")
}

