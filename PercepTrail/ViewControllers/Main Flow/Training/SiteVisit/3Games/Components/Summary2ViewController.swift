//
//  Summary2ViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import MKRingProgressView
import SDWebImage

class Summary2ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vPointRing: RingProgressView!
    @IBOutlet weak var vTimeRing: RingProgressView!
    @IBOutlet weak var imgPartner: UIImageView!
    
    // MARK: - Properties
    
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var totalPoint: Int = 0
    
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
    }
    
    fileprivate func setupImage() {
        imgPartner.sd_setImage(with: URL(fileURLWithPath: Bundle.main.path(forResource: "summary", ofType: "gif")!))
    }


    
    private func updateProgressAnimated() {
        let finalProgress = calculateFinalProgress()
        print("finalProgress: \(finalProgress)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 2.0) {
                self.vPointRing.progress = finalProgress
            }
        }
        
        if totalPoint > UserPreferences.shared.MaxQQScore {
            UserPreferences.shared.MaxQQScore = totalPoint
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
        
        UserPreferences.shared.TotalScore += totalPoint
        
        if totalPoint < 0 {
            totalPoint = 20
        }
    }
    
    private func calculateFinalProgress() -> Double {
        var progress: Double
        if UserPreferences.shared.MaxQQScore == 0 {
            UserPreferences.shared.MaxQQScore = totalPoint
            progress = 1.0
        } else {
            let maxPointPreference = UserPreferences.shared.MaxQQScore
            progress = Double(totalPoint) / Double(maxPointPreference)
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
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "Summary2ViewController")
}
