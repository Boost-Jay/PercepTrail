//
//  SettlementViewController.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/27.
//

import UIKit

class SettlementViewController: UIViewController {

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.pushToTakeCameraVC(self)
        }
    }

    // MARK: - Function

    func pushToTakeCameraVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TakePhone", bundle: nil)
        if let takePhotoVC = storyboard.instantiateViewController(withIdentifier: "TakePhoneViewController") as? TakePhoneViewController {
            takePhotoVC.fromSettlement = true
            present(takePhotoVC, animated: true, completion: nil)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = UIStoryboard(name: "SiteVisit", bundle: nil)
    return vc.instantiateViewController(withIdentifier: "SettlementViewController")
}

// 要在這裡加上判斷
// 是否抽到 IdentificationViewController 頁面
// 如果有的話要在這裡先打好 API 判斷，來去減少浪費時間
// 然後再把資料傳給下一個頁面
