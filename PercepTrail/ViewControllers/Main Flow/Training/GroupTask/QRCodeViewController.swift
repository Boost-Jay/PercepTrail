//
//  QRCodeViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/7/4.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var vQRCode: UIView!
    @IBOutlet weak var btnStartTask: UIButton!
    
    
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
    
    @IBAction func backToGame(_ sender: Any) {
    }
    
    @IBAction func pushToScan(_ sender: Any) {
    }
    
    @IBAction func pushToTaskVC(_ sender: Any) {
    }
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "GroupTask", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "QRCodeViewController")
}


