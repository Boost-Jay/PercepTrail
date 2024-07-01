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
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    // MARK: - Properties
    
    var correctCount: Int = 0
    var incorrectCount: Int = 0
    var totalPoint: Int = 0
    var totalTime: Int = 0
    var source: String?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        calculatePoints()
        setupUI()
    }
    
    fileprivate func setupUI() {
        vPointRing.progress = 0.0
        vTimeRing.progress = 0.0
        updateProgressAnimated()
        setupImage()
        lbScore.text = "+ \(totalPoint)"
        lbTime.text = "\(totalTime) 秒"
    }
    
    fileprivate func setupImage() {
        imgPartner.sd_setImage(with: URL(fileURLWithPath: Bundle.main.path(forResource: "summary", ofType: "gif")!))
    }

    private func updateProgressAnimated() {
        let finalProgress = calculateFinalProgress()
        
        let finalTimeProgress = calculateTimeProgress()
        
        print("totalTime\(totalTime)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 2.0) {
                self.vPointRing.progress = finalProgress
                self.vTimeRing.progress = finalTimeProgress
            }
        }
        
        
        updateMaxScore()
    }

    
    // MARK: - IBAction
    
    @IBAction func homeButtonPressed(_ unwindSegue: UIStoryboardSegue) {
        UserPreferences.shared.totalScore += (totalPoint + 2000)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            present(homeVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    
//    fileprivate func calculatePoints() {
//        let pointsFromCorrect = correctCount * 100
//        let pointsFromIncorrect = incorrectCount * 50
//        
//        totalPoint = pointsFromCorrect - pointsFromIncorrect
//        UserPreferences.shared.totalScore += totalPoint
//
//        if totalPoint < 0 {
//            totalPoint = 20
//        }
//    }
    
    private func updateMaxScore() {
        if let sourceType = source {
            switch sourceType {
            case "Pairing":
                if totalPoint > UserPreferences.shared.pairMaxScore {
                    UserPreferences.shared.pairMaxScore = totalPoint
                }
            case "Identification":
                if totalPoint > UserPreferences.shared.identificationMaxScore {
                    UserPreferences.shared.identificationMaxScore = totalPoint
                }
            case "Puzzle":
                if totalPoint > UserPreferences.shared.puzzleMaxScore {
                    UserPreferences.shared.puzzleMaxScore = totalPoint
                }
            default:
                break
            }
        }
    }
    
    private func calculateTimeProgress() -> Double {
        let timePerCircle = 30.0  // 每圈時間
        let progress = Double(totalTime) / timePerCircle
        let formattedProgress = String(format: "%.2f", progress)
        return Double(formattedProgress) ?? progress
    }

    
    private func calculateFinalProgress() -> Double {
        var progress: Double = 0.0
        var maxScore = 0

        if let sourceType = source {
            switch sourceType {
            case "Pairing":
                maxScore = UserPreferences.shared.pairMaxScore
            case "Identification":
                maxScore = UserPreferences.shared.identificationMaxScore
            case "Puzzle":
                maxScore = UserPreferences.shared.puzzleMaxScore
            default:
                break
            }
        }

        if maxScore == 0 {
            maxScore = totalPoint
            progress = 1.0
        } else {
            progress = Double(totalPoint) / Double(maxScore)
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
