//
//  WheelViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/21/24.
//

import UIKit
import SwiftFortuneWheel

class WheelViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vWheel: SwiftFortuneWheel! {
        didSet {
            vWheel.configuration = .variousWheelPodiumConfiguration
            vWheel.slices = slices
            vWheel.spinImage = "blueAnchorImage"
            vWheel.isSpinEnabled = false
        }
    }
    
    
    // MARK: - Properties
    
    var currentStopIndex: Int?
    
    var prizes = [(name: "1分鐘", color: #colorLiteral(red: 0.8828339577, green: 0.3921767175, blue: 0.4065475464, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
                  (name: "2分鐘", color: #colorLiteral(red: 1, green: 0.5892302394, blue: 0.3198351264, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
                  (name: "3分鐘", color: #colorLiteral(red: 0.3287895918, green: 0.3738358617, blue: 0.8356924653, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]
    
    lazy var slices: [Slice] = {
        var slices: [Slice] = []
        for prize in prizes {
            let sliceContent = [Slice.ContentType.text(text: prize.name, preferences: .variousWheelPodiumText(textColor: prize.textColor))]
            var slice = Slice(contents: sliceContent, backgroundColor: prize.color)
            slices.append(slice)
        }
        return slices
    }()
    
    var finishIndex: Int {
        return Int.random(in: 0..<vWheel.slices.count)
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        
    }
    
    // MARK: - IBAction
    
    @IBAction func rotateTap(_ sender: Any) {
        let stopIndex = finishIndex
        currentStopIndex = stopIndex
        
        vWheel.startRotationAnimation(finishIndex: stopIndex, continuousRotationTime: 1) { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                print("轉盤停止於： \(self.prizes[stopIndex].name)")

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.performSegue(withIdentifier: "pushToTimerVC", sender: nil)
                }
            }
        }
    }


    
    
    // MARK: - Function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToTimerVC" {
            if let destinationVC = segue.destination as? TimerViewController {
                if let stopIndex = currentStopIndex {
                    destinationVC.prizeName = prizes[stopIndex].name
                }
            }
        }
    }
}

// MARK: - Extensions

extension TextPreferences {
    static func variousWheelPodiumText(textColor: UIColor) -> TextPreferences {

        let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: textColor)
        
        var font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        var horizontalOffset: CGFloat = 0
        
        if let customFont = UIFont(name: "DINCondensed-Bold", size: 30) {
            font = customFont
            horizontalOffset = -2
        }
    
        var textPreferences = TextPreferences(textColorType: textColorType,
                                                 font: font,
                                                 verticalOffset: 5)
        
        textPreferences.horizontalOffset = horizontalOffset
        textPreferences.orientation = .vertical
        textPreferences.alignment = .right
        
        return textPreferences
    }
}

extension SFWConfiguration {
    static var variousWheelPodiumConfiguration: SFWConfiguration {
        
        let spin = SFWConfiguration.SpinButtonPreferences(size: CGSize(width: 64, height: 64))
        
        let sliceColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: .white)
        
        let slicePreferences = SFWConfiguration.SlicePreferences(backgroundColorType: sliceColorType, strokeWidth: 0, strokeColor: .white)
        
        let anchorImage = SFWConfiguration.AnchorImage(imageName: "anchorImage", size: CGSize(width: 8, height: 8), verticalOffset: -10)
        
        let circlePreferences = SFWConfiguration.CirclePreferences(strokeWidth: 1, strokeColor: UIColor.init(red: 32/255, green: 93/255, blue: 97/255, alpha: 1))
        
        var wheelPreferences = SFWConfiguration.WheelPreferences(circlePreferences: circlePreferences,
                                                                 slicePreferences: slicePreferences,
                                                                 startPosition: .right)
        
        wheelPreferences.imageAnchor = anchorImage

        let configuration = SFWConfiguration(wheelPreferences: wheelPreferences, spinButtonPreferences: spin)

        return configuration
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "QuickQuiz", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "WheelViewController")
}



