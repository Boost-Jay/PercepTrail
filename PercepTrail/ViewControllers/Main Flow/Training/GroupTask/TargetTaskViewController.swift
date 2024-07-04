//
//  TargetTaskViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/7/4.
//

import SwiftUI
import UIKit
import MaterialShowcase
import ProgressIndicatorView

// MARK: - TargetTaskViewController

class TargetTaskViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet var lbHint: UILabel!
    @IBOutlet var imgPartner: UIImageView!
    @IBOutlet var btnCamera: UIButton!
    
    // MARK: - Properties

    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    var progress: CGFloat = 0.0
    var progressData = ProgressData()
    var timer: Timer?
    var correctCount = 0
    var incorrectCount = 0
    var currentQuestion: AppDefine.Question = .p1
    var hintTimer: Timer?
    var secondsPassed = 0.0
    let sequence = MaterialShowcaseSequence()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startProgressTimer()
        startHintTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hintTimer?.invalidate()
    }

    // MARK: - UI Settings

    fileprivate func setupUI() {
        addProgressIndicator()
        setupImage()
        addShowCase()
        setupButtonImage()
    }
    
    private func setupButtonImage() {
        if let image1 = UIImage(systemName: "camera.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            let resizedImage = image1.resizeImage(to: CGSize(width: 70, height: 60))
            btnCamera.setImage(resizedImage, for: .normal)
        }
    }

    private func setupImage() {
        imgPartner.alpha = 1.0
        imgPartner.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
        imgPartner.layer.cornerRadius = 15
        imgPartner.layer.masksToBounds = true
        imgPartner.image = UIImage(named: "partner")
    }

    private func addShowCase() {
        DispatchQueue.main.async {
            let oneTimeKey = "third"
            let showcase1 = self.createShowcase(for: self.btnCamera,
                                                withText: "請前往尋找與目標相符的物品，並和他拍照做個留念吧！",
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
        showCase.targetHolderRadius = 70
        showCase.targetHolderColor = .clear
        showCase.isTapRecognizerForTargetView = true

        return showCase
    }

    private func addProgressIndicator() {
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

    // MARK: - Function

    private func startHintTimer() {
        hintTimer = Timer.scheduledTimer(timeInterval: 31, target: self, selector: #selector(updateHint), userInfo: nil, repeats: true)
    }
    
    private func startProgressTimer() {
        let totalSeconds = 600
        progressData.progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let increment = 1.0 / CGFloat(totalSeconds)
            if self.progressData.progress < 1.0 {
                self.progressData.progress += increment
            } else {
                self.timer?.invalidate()
                self.performSegue(withIdentifier: "pushToSummaryVC", sender: self)
            }
        }
    }

    func dateFromFileName(_ fileName: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = String(fileName.prefix(14))
        return dateFormatter.date(from: dateStr)
    }

    func isPhotoFromTodayOrYesterday(photoDate: Date) -> (isToday: Bool, isYesterday: Bool) {
        let calendar = Calendar.current
        if calendar.isDateInToday(photoDate) {
            return (true, false)
        } else if calendar.isDateInYesterday(photoDate) {
            return (false, true)
        }
        return (false, false)
    }

    func databaseHasPhotos() -> Bool {
        let photos = LocalDatabase.shared.fetchPhotos()
        return !photos.isEmpty
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToSummaryVC" {
            if let summaryVC = segue.destination as? SummaryViewController {
                summaryVC.correctCount = correctCount
                summaryVC.incorrectCount = incorrectCount
            }
        }
    }
}

// MARK: - LevelViewController: MaterialShowcaseDelegate

extension TargetTaskViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "GroupTask", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "TargetTaskViewController")
}
