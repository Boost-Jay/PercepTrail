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
        
        /// 設定 → 飛航模式
        case AirplaneMode = "App-prefs:AIRPLANE_MODE"
        
        /// 設定 → Wi-Fi
        case WiFi = "App-prefs:WIFI"
        
        /// 設定 → 藍牙
        case Bluetooth = "App-prefs:Bluetooth"
        
        /// 設定 → 個人熱點
        case InternetTethering = "App-prefs:INTERNET_TETHERING"
        
        /// 設定 → 通知
        case Notifications = "App-prefs:NOTIFICATIONS_ID"
        
        /// 設定 → 聲音與觸覺回饋
        case Sounds = "App-prefs:Sounds"
        
        /// 設定 → 聲音與觸覺回饋 → 鈴聲
        case Ringtone = "App-prefs:Sounds&path=Ringtone"
        
        /// 設定 → 勿擾模式
        case DonotDisturb = "App-prefs:DO_NOT_DISTURB"
        
        /// 設定 → 螢幕顯示與亮度 → 自動鎖定
        case AutoLock = "App-prefs:General&path=AUTOLOCK"
        
        /// 設定 → 背景圖片
        case Wallpaper = "App-prefs:Wallpaper"
        
        /// 設定 → Touch ID 與密碼／Face ID 與密碼
        case Passcode = "App-prefs:PASSCODE"
        
        /// 設定 → App Store
        case AppStore = "App-prefs:STORE"
        
        /// 設定 -> 密碼
        case Password = "App-prefs:PASSWORDS"
        
        /// 設定 → 備忘錄
        case Notes = "App-prefs:NOTES"
        
        /// 設定 → 電話
        case Phone = "App-prefs:Phone"
        
        /// 設定 → FaceTime
        case Facetime = "App-prefs:FACETIME"
        
        /// 設定 → 音樂
        case Music = "App-prefs:MUSIC"

        /// 設定 → 照片
        case Photos = "App-prefs:Photos"
        
        // MARK: 設定 -> Apple ID
        
        /// 設定 → Apple ID → iCloud
        case iCloud = "App-prefs:CASTLE"
        
        /// 設定 → Apple ID → iCloud
        case iCloudStorageAndBackup = "App-prefs:CASTLE&path=STORAGE_AND_BACKUP"
        
        // MARK: 設定 -> 一般
        
        /// 設定 → 一般
        case General = "App-prefs:General"
        
        /// 設定 → 一般 → 關於本機
        case About = "App-prefs:General&path=About"
        
        /// 設定 → 一般 → 軟體更新
        case SoftwareUpdate = "App-prefs:General&path=SOFTWARE_UPDATE_LINK"
        
        /// 設定 → 一般 → 日期與時間
        case DateAndTime = "App-prefs:General&path=DATE_AND_TIME"
        
        /// 設定 → 一般 → 鍵盤
        case Keyboard = "App-prefs:General&path=Keyboard"
        
        /// 設定 → 一般 → 語言與地區
        case LanguageAndRegion = "App-prefs:General&path=INTERNATIONAL"
        
        /// 設定 → 一般 → 描述檔
        case ManagedConfigurationList = "App-prefs:General&path=ManagedConfigurationList"
        
        /// 設定 → 一般 → 重置
        case Reset = "App-prefs:General&path=Reset"
    }
}
