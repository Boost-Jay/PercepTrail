//
//  ExerciseViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit

class ExerciseViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var txfExerciseTime: UITextField!
    @IBOutlet var sldExerciseTime: UISlider!

    // MARK: - Properties

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Settings

    fileprivate func setupUI() {
        txfExerciseTime.delegate = self

        // 設定文本欄位的鍵盤類型為數字
        txfExerciseTime.keyboardType = .numberPad

        // 初始化滑塊的範圍和初始值
        sldExerciseTime.minimumValue = 20
        sldExerciseTime.maximumValue = 120
        sldExerciseTime.value = 20

        // 設定文本欄位初始值
        txfExerciseTime.text = "\(Int(sldExerciseTime.value))"

        // 監聽文本欄位和滑塊的值變化
        txfExerciseTime.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        sldExerciseTime.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    // MARK: - IBAction

    @IBAction func pushToWorkoutVC(_ sender: Any) {
        UserPreferences.shared.userExerciseTime = Int(sldExerciseTime.value)
        DispatchQueue.main.async {
            Alert.showToastWith(message: "保存成功！", vc: self, during: .long, dismiss: {
                self.performSegue(withIdentifier: "showWorkoutPage", sender: nil)
            })

        }
    }

    // MARK: - Action

    @objc func textFieldChanged() {
        if let text = txfExerciseTime.text, let value = Int(text) {
            sldExerciseTime.value = Float(value)
        }
    }
    
    @objc func sliderValueChanged() {
        txfExerciseTime.text = "\(Int(sldExerciseTime.value))"
    }
}

// MARK: - Extension

extension ExerciseViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = Int(textField.text ?? "") ?? 20
        let clampedValue = min(max(value, 20), 120)
        textField.text = "\(clampedValue)"
        sldExerciseTime.value = Float(clampedValue)
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "ExerciseViewController")
}
