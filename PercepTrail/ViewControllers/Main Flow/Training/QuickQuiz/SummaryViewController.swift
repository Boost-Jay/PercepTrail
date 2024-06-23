//
//  SummaryViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import MKRingProgressView

class SummaryViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTotalPoints: UILabel!
    @IBOutlet weak var vPointRing: RingProgressView!
    
    // MARK: - Properties
    
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var maxPoint: Int = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePoints()
        setupUI()
    }
    
    fileprivate func setupUI() {
        vPointRing.progress = 0.0
        lbTotalPoints.text = "+ \(maxPoint)"
        updateProgressAnimated()
    }
    
    private func updateProgressAnimated() {
        let finalProgress = calculateFinalProgress()
        print("finalProgress: \(finalProgress)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 2.0) {
                self.vPointRing.progress = finalProgress
            }
        }
        
        if maxPoint > UserPreferences.shared.QQScore {
            UserPreferences.shared.QQScore = maxPoint
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
        maxPoint = pointsFromCorrect - pointsFromIncorrect
        
        UserPreferences.shared.TotalScore += maxPoint
        
        if maxPoint < 0 {
            maxPoint = 20
        }
    }
    
    private func calculateFinalProgress() -> Double {
        var progress: Double
        if UserPreferences.shared.QQScore == 0 {
            UserPreferences.shared.QQScore = maxPoint
            progress = 1.0
        } else {
            let maxPointPreference = UserPreferences.shared.QQScore
            progress = Double(maxPoint) / Double(maxPointPreference)
        }
        
        if progress > 3 {
            progress = 3.0
        }
        
        let formattedProgress = String(format: "%.2f", progress)
        return Double(formattedProgress) ?? progress
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "SummaryViewController")
}
