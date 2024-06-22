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
    
    var prizeName: String?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        lbTimer.text = "計時：\(prizeName ?? "無資料")"
    }
    
    // MARK: - IBAction
    
    @IBAction func pushToLevelVC(_ sender: Any) {
        performSegue(withIdentifier: "pushToLevelVC", sender: nil)
    }
    
    
    // MARK: - Function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToLevelVC" {
            if let levelVC = segue.destination as? LevelViewController {
                if let firstChar = prizeName?.first, let firstNumber = Int(String(firstChar)) {
                    levelVC.prizeTime = firstNumber
                }
            }
        }
    }

    
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TimerViewController")
}



