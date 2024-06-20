//
//  TrainingMainViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/20/24.
//

import UIKit

class TrainingMainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vProgressRing: UIView!
    @IBOutlet weak var lbTotalPoints: UILabel!
    @IBOutlet weak var lbWalkingDistance: UILabel!
    @IBOutlet weak var lbTrainingTime: UILabel!
        
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
    
    @IBAction func showTakePhotoVC(_ sender: Any) {
        print("1")
    }
    
    @IBAction func showSiteVisitVC(_ sender: Any) {
        print("2")
    }
    
    @IBAction func showQuickQuizVC(_ sender: Any) {
        print("3")
    }
    
    @IBAction func showGroupTask(_ sender: Any) {
        print("4")
    }
    
    // MARK: - Function
    
    
    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TrainingMainViewController")
}


