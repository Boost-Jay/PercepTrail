//
//  LevelViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import SwiftUI
import ProgressIndicatorView
import MaterialShowcase

// MARK: - LevelViewController

class LevelViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var imgPartner: UIImageView!
    @IBOutlet weak var btnTrue: UIButton!
    @IBOutlet weak var btnFalse: UIButton!
    
    
    // MARK: - Properties
    
    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    var prizeTime: Int?
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
        loadQuestion()
        setupImage()
        addShowCase()
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
            let showcase1 = self.createShowcase(for: self.btnTrue,
                                                withText: "圖片與題目相符，請點擊此處",
                                                withColor: .showcase)
            let showcase2 = self.createShowcase(for: self.btnFalse,
                                                withText: "圖片與題目無關，請點擊此處",
                                                withColor: .showcase)

            self.sequence
                .temp(showcase1)
                .temp(showcase2)
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
        self.addChild(hostingController)
        
        let screenWidth = UIScreen.main.bounds.width
        hostingController.view.frame = CGRect(x: 0, y: 180, width: screenWidth, height: 25)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.progressIndicatorViewController = hostingController
    }
    
    // MARK: - IBAction
    
    @IBAction func isClickedTrue(_ sender: Any) {
        checkAnswer(userAnswer: true)
    }
    
    @IBAction func isClickedFalse(_ sender: Any) {
        checkAnswer(userAnswer: false)
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
    
    // MARK: - Function
    
    private func checkAnswer(userAnswer: Bool) {
        var isCorrect = false
        switch AppDefine.currentQuestionType {
        case .predefined(let question):
            isCorrect = (userAnswer == question.isCorrect)
        case .photoQuestion(_, _, let correctAnswer):
            isCorrect = (userAnswer == correctAnswer)
        }
        
        if isCorrect {
            correctCount += 1
            print("Correct: \(correctCount)")
        } else {
            incorrectCount += 1
            print("Incorrect: \(incorrectCount)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadQuestion()
        }
    }
    
    private func startHintTimer() {
        hintTimer = Timer.scheduledTimer(timeInterval: 31, target: self, selector: #selector(updateHint), userInfo: nil, repeats: true)
    }
    
    private func loadQuestion() {
        let hasPhotos = databaseHasPhotos()
        
        if hasPhotos && Bool.random() {
            let photos = LocalDatabase.shared.fetchPhotos()
            if let randomPhoto = photos.randomElement() {
                let date = dateFromFileName(randomPhoto.name)
                let check = isPhotoFromTodayOrYesterday(photoDate: date ?? Date())
                let questionText = check.isToday ? "這是今天的？" : (check.isYesterday ? "這是昨天的？" : "這是過去的？")
                let correctAnswer = check.isToday || check.isYesterday
                
                AppDefine.currentQuestionType = .photoQuestion(questionText, UIImage(contentsOfFile: randomPhoto.path) ?? UIImage(), correctAnswer)
                imgQuestion.image = UIImage(contentsOfFile: randomPhoto.path)
                lbQuestion.text = questionText
            }
        } else {
            let question = AppDefine.Question.allCases.randomElement() ?? .p1
            AppDefine.currentQuestionType = .predefined(question)
            imgQuestion.image = question.image
            lbQuestion.text = question.description
        }
    }
    
    private func startProgressTimer() {
        guard let duration = prizeTime else { return }
        let totalSeconds = duration * 5
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
                summaryVC.correctCount = self.correctCount
                summaryVC.incorrectCount = self.incorrectCount
            }
        }
    }
}

// MARK: - LevelViewController: MaterialShowcaseDelegate

extension LevelViewController: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "LevelViewController")
}
