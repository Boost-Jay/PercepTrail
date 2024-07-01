//
//  WelcomeViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/19/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    
    
    // MARK: - Properties
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        
    }
    
    // MARK: - IBAction
    
    @IBAction func pushToNicknameVC(_ sender: Any) {
        self.performSegue(withIdentifier: "welcomeToNicknameSegue", sender: nil)
    }

    
    @IBAction func confirmedPrivacy(_ sender: Any) {
        
    }
    
    @IBAction func pushToPrivacyConsentVC(_ sender: Any) {
        performSegue(withIdentifier: "welcomeToPrivacyConsentSegue", sender: self)
    }
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Initial", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "WelcomeViewController")
}


