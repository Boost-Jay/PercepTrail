//
//  WorkoutViewController.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import UIKit

class WorkoutViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var txfStep: UITextField!
    @IBOutlet var sldStep: UISlider!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Settings

    fileprivate func setupUI() {
        txfStep.delegate = self

        // 設定文本欄位的鍵盤類型為數字
        txfStep.keyboardType = .numberPad

        // 初始化滑塊的範圍和初始值
        sldStep.minimumValue = 4000
        sldStep.maximumValue = 20000
        sldStep.value = 6000

        // 設定文本欄位初始值
        txfStep.text = "\(Int(sldStep.value))"

        // 監聽文本欄位和滑塊的值變化
        txfStep.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        sldStep.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    // MARK: - IBAction

    @IBAction func pushToMainVC(_ sender: Any) {
        UserPreferences.shared.userStep = Int(sldStep.value)
        UserPreferences.shared.finishInit = true
        DispatchQueue.main.async {
            Alert.showToastWith(message: "保存成功！", vc: self, during: .long, dismiss: {
                self.performSegue(withIdentifier: "showMainPage", sender: nil)
            })
        }
    }

    // MARK: - Action

    @objc func textFieldChanged() {
        if let text = txfStep.text, let value = Int(text) {
            sldStep.value = Float(value)
        }
    }

    @objc func sliderValueChanged() {
        txfStep.text = "\(Int(sldStep.value))"
    }
}

// MARK: - Extensions

extension WorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = Int(textField.text ?? "") ?? 4000
        let clampedValue = min(max(value, 4000), 20000)
        textField.text = "\(clampedValue)"
        sldStep.value = Float(clampedValue)
    }
}

// MARK: - Protocols

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "Main", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "WorkoutViewController")
}
