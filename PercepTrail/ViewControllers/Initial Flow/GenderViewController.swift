//
//  GenderViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/19/24.
//

import UIKit

class GenderViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    
    
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
    
    
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Initial", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "GenderViewController")
}


