//
//  IdentificationViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import ProgressIndicatorView
import SwiftUI
import UIKit

class IdentificationViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var imgPartner: UIImageView!
    @IBOutlet var lbHint: UILabel!
    @IBOutlet var lbQuestion: UILabel!

    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    @IBOutlet var img4: UIImageView!

    // MARK: - Properties

    var progressData = ProgressData()
    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    var timer: Timer?
    var hintTimer: Timer?
    var secondsPassed = 0.0
    var score = 0

    var photos: [UIImage] = []
    var questionText: String = ""
    var answerArray: [Int] = []

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startHintTimer()
        startProgressTimer()

        print("answerArrayaaaa:::\(answerArray)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hintTimer?.invalidate()
    }

    // MARK: - UI Settings

    fileprivate func setupUI() {
        addProgressIndicator()
        setupImage()
        setupPhotosAndQuestion()
    }

    private func setupPhotosAndQuestion() {
        lbQuestion.text = questionText

        let imageViews = [img1, img2, img3, img4]
        for (index, imageView) in imageViews.enumerated() {
            imageView?.isUserInteractionEnabled = true
            imageView?.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
            imageView?.addGestureRecognizer(tapGesture)
            if index < photos.count {
                imageView?.image = photos[index]
            }
        }
    }

    private func setupImage() {
        imgPartner.alpha = 1.0
        imgPartner.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
        imgPartner.layer.cornerRadius = 15
        imgPartner.layer.masksToBounds = true
        imgPartner.image = UIImage(named: "partner")
    }

    func addProgressIndicator() {
        let progressView = ProgressIndicatorViewWrapper(progressData: progressData)
        let hostingController = UIHostingController(rootView: progressView)
        addChild(hostingController)

        let screenWidth = UIScreen.main.bounds.width
        hostingController.view.frame = CGRect(x: 0, y: 180, width: screenWidth, height: 25)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        progressIndicatorViewController = hostingController
    }

    // MARK: - IBAction

    @IBAction func checkAnswer(_ sender: Any) {
        let userAnswers = [img1, img2, img3, img4].map { $0.layer.borderWidth > 0 ? 1 : 0 }
        if userAnswers == answerArray {
            calculateScore()
            Alert.showToastWith(message: "恭喜通過！", vc: self, during: .long, dismiss: {
                self.performSegue(withIdentifier: "fromIdentificationToSummary", sender: nil)
            })
        } else {
            clearBorders()
            score -= 20
            Alert.showToastWith(message: "請再試試看！", vc: self, during: .short)
        }
    }


    // MARK: - Action

    @objc func updateHint() {
        secondsPassed += 0.5
        switch secondsPassed {
        case 0.5:
            lbHint.text = "加油！"
        case 1.0:
            lbHint.text = "再接再厲！"
        case 1.5:
            lbHint.text = "堅持下去！"
        case 2.0:
            lbHint.text = "最後一分鐘！"
        case 2.5:
            lbHint.text = "進入最後階段"
        default:
            break
        }
    }

    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        print("Current borderWidth: \(imageView.layer.borderWidth)")
        
        if imageView.layer.borderWidth > 0 {
            imageView.layer.borderWidth = 0
            print("Hide border")
        } else {
            imageView.layer.borderWidth = 10
            imageView.layer.borderColor = UIColor.red.cgColor
            print("Show red border")
        }
    }

    // MARK: - Progress Timer

    private func startProgressTimer() {
        let totalSeconds = 180 // 3分鐘
        progressData.progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let increment = 1.0 / CGFloat(totalSeconds)
            if self.progressData.progress < 1.0 {
                self.progressData.progress += increment
            } else {
                self.timer?.invalidate()
                self.calculateScore()
                self.performSegue(withIdentifier: "fromIdentificationToSummary", sender: self)
            }
        }
    }

    // MARK: - Function

    private func startHintTimer() {
        hintTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateHint), userInfo: nil, repeats: true)
    }
    
    private func clearBorders() {
        [img1, img2, img3, img4].forEach { imageView in
            imageView.layer.borderWidth = 0
        }
    }
    
    private func calculateScore() {
        let timeRemaining = 180 - Int(progressData.progress * 180)
        switch timeRemaining {
        case 136...180:
            score += 1000
        case 91...135:
            score += 700
        case 46...90:
            score += 500
        case 0...45:
            score += 300
        default:
            break
        }
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromIdentificationToSummary" {
            if let summaryVC = segue.destination as? Summary2ViewController {
                summaryVC.totalPoint = score
                summaryVC.totalTime = Int(progressData.progress * 180)
                summaryVC.source = "Identification"
            }
        }
    }
    
    

}

// MARK: - Extensions

// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "IdentificationViewController")
}
