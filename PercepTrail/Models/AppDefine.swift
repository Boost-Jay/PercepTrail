//
//  AppDefine.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

struct AppDefine {

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
