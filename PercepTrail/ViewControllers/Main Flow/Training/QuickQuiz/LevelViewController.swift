//
//  LevelViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import SwiftUI
import ProgressIndicatorView

// MARK: - LevelViewController

class LevelViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var imgPartner: UIImageView!
    var progressIndicatorViewController: UIHostingController<ProgressIndicatorViewWrapper>?
    
    
    // MARK: - Properties
    
    var prizeTime: Int?
    var progress: CGFloat = 0.0
    var progressData = ProgressData()
    var timer: Timer?
    var correctCount = 0
    var incorrectCount = 0
    var currentQuestion: AppDefine.Question = .p1
    var hintTimer: Timer?
    var secondsPassed = 0.0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startProgressTimer()
        startHintTimer()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        addSwiftUIProgressIndicator()
        loadQuestion()
        setupImage()
    }
    
    private func setupImage() {
        imgPartner.alpha = 1.0
        imgPartner.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
        imgPartner.layer.cornerRadius = 15
        imgPartner.layer.masksToBounds = true
        imgPartner.image = UIImage(named: "partner")
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
        var isCorrect: Bool = false
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



    
    private func addSwiftUIProgressIndicator() {
        let progressIndicatorView = ProgressIndicatorViewWrapper(progressData: progressData)
        let hostingController = UIHostingController(rootView: progressIndicatorView)
        self.progressIndicatorViewController = hostingController
        
        addChild(hostingController)
        let screenWidth = UIScreen.main.bounds.width
        hostingController.view.frame = CGRect(x: 0, y: 180, width: screenWidth, height: 25)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hintTimer?.invalidate()
        timer?.invalidate()
    }
}

// MARK: - ProgressData

class ProgressData: ObservableObject {
    @Published var progress: CGFloat = 0.0
}

// MARK: - ProgressIndicatorViewWrapper

struct ProgressIndicatorViewWrapper: View {
    @ObservedObject var progressData: ProgressData
    
    var body: some View {
        ProgressIndicatorView(isVisible: .constant(true), type: .bar(progress: $progressData.progress, backgroundColor: .gray.opacity(0.25)))
            .frame(height: 8.0)
    }
}

// MARK: - CustomProgressIndicatorView

struct CustomProgressIndicatorView: View {
    @Binding var progress: CGFloat
    var backgroundColor: Color = .gray
    var foregroundColor: Color = .red
    
    var body: some View {
        ProgressIndicatorView(isVisible: .constant(true), type: .bar(progress: $progress, backgroundColor: backgroundColor))
            .frame(height: 8.0)
            .background(foregroundColor.opacity(0.5))
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "LevelViewController")
}




