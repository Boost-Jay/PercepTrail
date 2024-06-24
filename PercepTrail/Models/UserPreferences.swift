//
//  UserPreferences.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

final class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let userPreference: UserDefaults
    
    private init() {
        userPreference = UserDefaults.standard
        registerDefaults()
    }
    
    private func registerDefaults() {
        let defaults = [PreferenceKey.MaxQQScore.rawValue: 0]
        userPreference.register(defaults: defaults)
    }
    
    enum PreferenceKey: String {
        case MaxQQScore
        
        case TotalScore
    }
    
    var MaxQQScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.MaxQQScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.MaxQQScore.rawValue) }
    }
    
    
    var TotalScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.TotalScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.TotalScore.rawValue) }
    }
}
