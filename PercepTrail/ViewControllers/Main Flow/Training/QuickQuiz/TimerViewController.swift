//
//  TimerViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import MaterialShowcase

class TimerViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTimer: UILabel!
    
    @IBOutlet weak var btnStart: UIButton!
    
    // MARK: - Properties
    
    var prizeName: String?
    let sequence = MaterialShowcaseSequence()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        lbTimer.text = "計時：\(prizeName ?? "無資料")"
        addShowCase()
    }
    
    private func addShowCase() {
        DispatchQueue.main.async {
            let oneTimeKey = "second"
            let showcase1 = self.createShowcase(for: self.btnStart,
                                                withText: "準備好的話就可以點擊此處開始活動了！",
                                                withColor: .showcase)

            self.sequence
                .temp(showcase1)
                .setKey(key: oneTimeKey)
                .start()
        }
    }
    
    private func createShowcase(for view: UIView, withText: String, withColor: UIColor) -> MaterialShowcase {
        let showCase = MaterialShowcase()
        showCase.delegate = self
        showCase.setTargetView(view: view)
        showCase.primaryText = withText
        showCase.secondaryText = ""
        showCase.backgroundAlpha = 1
        showCase.shouldSetTintColor = false
        showCase.backgroundPromptColor = withColor
        showCase.backgroundPromptColorAlpha = 0.6
        showCase.backgroundViewType = .circle
        showCase.backgroundRadius = 400
        showCase.targetTintColor = .blue
        showCase.targetHolderRadius = 80
        showCase.targetHolderColor = .clear
        showCase.isTapRecognizerForTargetView = true
        
        return showCase
    }
    
    // MARK: - IBAction
    
    @IBAction func pushToLevelVC(_ sender: Any) {
        performSegue(withIdentifier: "pushToLevelVC", sender: nil)
    }
    
    // MARK: - Navigation
    
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

extension TimerViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TimerViewController")
}



