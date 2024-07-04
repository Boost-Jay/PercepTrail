//
//  PairingUserViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/7/4.
//

import UIKit

class PairingUserViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var tvGamer: UITableView!
    @IBOutlet weak var btnStart: UIButton!
    
    
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
    
    @IBAction func startGame(_ sender: Any) {
    }
    
    @IBAction func backToHome(_ sender: Any) {
    }
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "GroupTask", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "PairingUserViewController")
}


