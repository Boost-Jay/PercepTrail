//
//  AppDefine.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation
import UIKit

struct AppDefine {
    
    static var currentQuestionType: QuestionType = .predefined(.p1)
    
    enum Question: String, CaseIterable {
        case p1, p2, p3, p4, p5, p6, p7, p8, p9, p10,
             p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
             p21, p22, p23, p24, p25, p26, p27, p28

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }

        var description: String {
            switch self {
            case .p1:
                return "這是天空嗎？"
            case .p2:
                return "這是湖泊嗎？"
            case .p3:
                return "這是瀑布嗎？"
            case .p4:
                return "這是壽司嗎？"
            case .p5:
                return "這是醫院嗎？"
            case .p6:
                return "這是水管嗎？"
            case .p7:
                return "這是火車嗎？"
            case .p8:
                return "這是橋樑嗎？"
            case .p9:
                return "這是白天嗎？"
            case .p10:
                return "這是雞嗎？"
            case .p11:
                return "這是晴天嗎？"
            case .p12:
                return "這是島嶼嗎？"
            case .p13:
                return "這是海豚嗎？"
            case .p14:
                return "這是小鳥嗎？"
            case .p15:
                return "這是雲海嗎？"
            case .p16:
                return "這是晚上嗎？"
            case .p17:
                return "這是飛機嗎？"
            case .p18:
                return "這是狗嗎？"
            case .p19:
                return "這是珊瑚嗎？"
            case .p20:
                return "這是飲料嗎？"
            case .p21:
                return "這是包包嗎？"
            case .p22:
                return "這是青菜嗎？"
            case .p23:
                return "這是陰天嗎？"
            case .p24:
                return "這是紫色嗎？"
            case .p25:
                return "這是紅色嗎？"
            case .p26:
                return "這是咖啡色嗎？"
            case .p27:
                return "這是藍色嗎？"
            case .p28:
                return "這是灰色嗎？"
            }
        }

        var isCorrect: Bool {
            switch self {
            case .p2, .p3, .p4, .p7, .p8, .p9, .p11, .p12, .p13, .p15, .p16, .p17, .p18, .p20, .p21, .p23, .p24, .p26, .p27:
                return true
            default:
                return false
            }
        }
    }
    
    enum QuestionType {
        case predefined(AppDefine.Question)
        case photoQuestion(String, UIImage, Bool)  // (題目描述, 圖片, 正確答案)
    }


    // MARK: - enum SettingsURLScheme
    
    enum SettingsURLScheme: String {
        
        // MARK: 設定
        
        /// 設定
        case Settings = "App-prefs:Settings"
        
        /// 設定 → 位置
        case Location = "App-Prefs:Privacy&path=LOCATION"
        
        /// 設定 → 照片
        case Photos = "App-prefs:Privacy&path=PHOTOS"
        
        /// 設定 → 相機
        case Camera = "App-prefs:Privacy&path=CAMERA"

    }
}
