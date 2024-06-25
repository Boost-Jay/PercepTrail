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
        let defaults = [PreferenceKey.QQMaxScore.rawValue: 0]
        userPreference.register(defaults: defaults)
    }
    
    enum PreferenceKey: String {
        case QQMaxScore
        
        case PairMaxScore
        
        case IdentificationMaxScore
        
        case PuzzleMaxScore
        
        case TotalScore
    }
    
    var QQMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.QQMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.QQMaxScore.rawValue) }
    }
    
    
    var PairMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.PairMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.PairMaxScore.rawValue) }
    }
    
    var IdentificationMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.IdentificationMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.IdentificationMaxScore.rawValue) }
    }
    
    var PuzzleMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.PuzzleMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.PuzzleMaxScore.rawValue) }
    }
    
    var TotalScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.TotalScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.TotalScore.rawValue) }
    }
}
