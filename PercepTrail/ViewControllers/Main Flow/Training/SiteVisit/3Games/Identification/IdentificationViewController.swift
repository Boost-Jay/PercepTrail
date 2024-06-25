//
//  IdentificationViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit
import SwiftUI
import ProgressIndicatorView

class IdentificationViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img9: UIImageView!
    
    
    // MARK: - Properties
    var progressData = ProgressData()
    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    var timer: Timer?
    var hintTimer: Timer?
    var secondsPassed = 0.0
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startHintTimer()
        startProgressTimer()
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
    
    @IBAction func checkAnswer(_ sender: Any) {
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
    
    // MARK: - Progress Timer
    private func startProgressTimer() {
        let totalSeconds = 180  // 3分鐘
        progressData.progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let increment = 1.0 / CGFloat(totalSeconds)
            if self.progressData.progress < 1.0 {
                self.progressData.progress += increment
            } else {
                self.timer?.invalidate()
                self.performSegue(withIdentifier: "fromIdentificationToSummary", sender: self)
            }
        }
    }
    
    // MARK: - Function
    private func startHintTimer() {
        hintTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateHint), userInfo: nil, repeats: true)
    }
}

// MARK: - Extensions



// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "IdentificationViewController")
}


