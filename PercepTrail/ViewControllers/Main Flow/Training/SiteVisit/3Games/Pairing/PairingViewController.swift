//
//  PairingViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit
import SwiftUI
import ProgressIndicatorView

// MARK: - CardImage

struct CardImage: Hashable {
    var name: String
    var path: String
}

// MARK: - PairingViewController

class PairingViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    // MARK: - Properties
    
    var progressData = ProgressData()
    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    var timer: Timer?
    var hintTimer: Timer?
    var secondsPassed = 0.0
    var matchesFound = 0
    var score = 0
    
    var images: [CardImage] = []
    var selectedCards: [UIImageView] = []
    var flippedImages: [String] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startHintTimer()
        startProgressTimer()
        fetchRandomPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hintTimer?.invalidate()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        addProgressIndicator()
        setupImage()
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
        self.addChild(hostingController)
        
        let screenWidth = UIScreen.main.bounds.width
        hostingController.view.frame = CGRect(x: 0, y: 180, width: screenWidth, height: 25)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.progressIndicatorViewController = hostingController
    }
    
    // MARK: - IBAction
    
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        // 檢查是否這張牌已被選擇
        if selectedCards.contains(imageView) {
            return // 如果已選擇這張牌，直接返回不做處理
        }

        let card = images[imageView.tag]
        
        // 翻牌
        imageView.image = UIImage(contentsOfFile: card.path)
        flippedImages.append(card.name)
        selectedCards.append(imageView)
        
        if selectedCards.count == 2 {
            checkMatch(imageView)
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
                score += 70
                self.performSegue(withIdentifier: "fromPairToSummary", sender: self)
            }
        }
    }
    
    // MARK: - Function
    
    private func startHintTimer() {
        hintTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateHint), userInfo: nil, repeats: true)
    }
    
    func fetchRandomPhotos() {
        let photos = LocalDatabase.shared.fetchPhotos()
        guard photos.count >= 3 else { return }
        
        var selectedPhotos = Set<CardImage>()
        while selectedPhotos.count < 3 {
            let randomIndex = Int.random(in: 0..<photos.count)
            let photo = photos[randomIndex]
            selectedPhotos.insert(CardImage(name: photo.name, path: photo.path))
        }
        
        images = Array(selectedPhotos) + Array(selectedPhotos)
        images.shuffle()
        
        setupImages()
    }
    
    func setupImages() {
        let imageViews = [img1, img2, img3, img4, img5, img6]
        for (index, imageView) in imageViews.enumerated() {
            imageView?.isUserInteractionEnabled = true
            imageView?.tag = index
            imageView?.image = UIImage(named: "maskCard")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView?.addGestureRecognizer(tapGesture)
        }
    }
    
    func checkMatch(_ currentImageView: UIImageView) {
        if selectedCards.count == 2 {
            let firstCard = selectedCards[0]
            let secondCard = selectedCards[1]

            if flippedImages[0] == flippedImages[1] {
                print("Match found!")
                matchesFound += 1
                updateScore()

                // 清空翻牌記錄，但保留顯示
                flippedImages.removeAll()
                selectedCards.removeAll()
            } else {
                // 不匹配，設置延遲翻回蓋牌
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    firstCard.image = UIImage(named: "maskCard")
                    secondCard.image = UIImage(named: "maskCard")

                    // 清空翻牌記錄
                    self.flippedImages.removeAll()
                    self.selectedCards.removeAll()
                }
            }
        }
    }
    
    func updateScore() {
        guard matchesFound == 3 else { return } // 只有當匹配三次時計算分數

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

        print("Score: \(score)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "fromPairToSummary", sender: self)
            }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPairToSummary" {
            if let summaryVC = segue.destination as? Summary2ViewController {
                summaryVC.totalPoint = score
                summaryVC.totalTime = Int(progressData.progress * 180)
                summaryVC.source = "Pairing"
            }
        }
    }

}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "PairingViewController")
}
