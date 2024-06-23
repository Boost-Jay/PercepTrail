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
        let defaults = [PreferenceKey.maxPoint.rawValue: 0]
        userPreference.register(defaults: defaults)
    }
    
    enum PreferenceKey: String {
        case maxPoint
        
        case TotalScore
    }
    
    var maxPoint: Int {
        get { userPreference.integer(forKey: PreferenceKey.maxPoint.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.maxPoint.rawValue) }
    }
    
    
    var TotalScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.TotalScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.TotalScore.rawValue) }
    }
}
