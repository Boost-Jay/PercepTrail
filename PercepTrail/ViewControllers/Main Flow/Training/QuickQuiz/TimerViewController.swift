//
//  TimerViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit

class TimerViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTimer: UILabel!
    
    
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
    
    @IBAction func pushToLevelVC(_ sender: Any) {
    }
    
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TimerViewController")
}


