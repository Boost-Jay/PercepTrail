//
//  SummaryViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import MKRingProgressView
import SDWebImage
import MaterialShowcase

class SummaryViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTotalPoints: UILabel!
    @IBOutlet weak var vPointRing: RingProgressView!
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var btnHome: UIButton!
    
    // MARK: - Properties
    
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var totalPoint: Int = 0
    let sequence = MaterialShowcaseSequence()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePoints()
        setupUI()
    }
    
    fileprivate func setupUI() {
        vPointRing.progress = 0.0
        lbTotalPoints.text = "+ \(totalPoint)"
        updateProgressAnimated()
        setupImage()
        addShowCase()
    }
    
    fileprivate func setupImage() {
        imgPartner.sd_setImage(with: URL(fileURLWithPath: Bundle.main.path(forResource: "summary", ofType: "gif")!))
    }
    
    private func addShowCase() {
        DispatchQueue.main.async {
            let oneTimeKey = "fouth"
            let showcase1 = self.createShowcase(for: self.btnHome,
                                                withText: "恭喜你完成了這次挑戰，別忘了回主頁查看總分！",
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
        showCase.backgroundRadius = 300
        showCase.targetTintColor = .blue
        showCase.targetHolderRadius = 100
        showCase.targetHolderColor = .clear
        showCase.isTapRecognizerForTargetView = true
        
        return showCase
    }
    
    private func updateProgressAnimated() {
        let finalProgress = calculateFinalProgress()
        print("finalProgress: \(finalProgress)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 2.0) {
                self.vPointRing.progress = finalProgress
            }
        }
        
        if totalPoint > UserPreferences.shared.qqMaxScore {
            UserPreferences.shared.qqMaxScore = totalPoint
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func homeButtonPressed(_ unwindSegue: UIStoryboardSegue) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            present(homeVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    fileprivate func calculatePoints() {
        let pointsFromCorrect = correctCount * 100
        let pointsFromIncorrect = incorrectCount * 50
        
        totalPoint = pointsFromCorrect - pointsFromIncorrect
        
        if totalPoint < 0 {
            totalPoint = 20
        }
        UserPreferences.shared.totalScore += totalPoint
    }
    
    private func calculateFinalProgress() -> Double {
        var progress: Double
        if UserPreferences.shared.qqMaxScore == 0 {
            UserPreferences.shared.qqMaxScore = totalPoint
            progress = 1.0
        } else {
            let maxPointPreference = UserPreferences.shared.qqMaxScore
            progress = Double(totalPoint) / Double(maxPointPreference)
        }
        
        if progress > 3 {
            progress = 3.0
        }
        
        let formattedProgress = String(format: "%.2f", progress)
        return Double(formattedProgress) ?? progress
    }
}

// MARK: - Extension

extension SummaryViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "SummaryViewController")
}
