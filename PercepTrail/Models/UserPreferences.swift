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
        let defaults = [
            PreferenceKey.qqMaxScore.rawValue: 0,
            PreferenceKey.pairMaxScore.rawValue: 0,
            PreferenceKey.identificationMaxScore.rawValue: 0,
            PreferenceKey.puzzleMaxScore.rawValue: 0,
            PreferenceKey.totalScore.rawValue: 0,
            PreferenceKey.userStep.rawValue: 0,
            PreferenceKey.userExerciseTime.rawValue: 0,
            PreferenceKey.finishInit.rawValue: false
        ] as [String : Any]
        userPreference.register(defaults: defaults)
    }

    enum PreferenceKey: String {
        case qqMaxScore
        
        case pairMaxScore
        
        case identificationMaxScore
        
        case puzzleMaxScore
        
        case totalScore
        
        case userStep
        
        case userExerciseTime
        
        case finishInit
    }
    
    var qqMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.qqMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.qqMaxScore.rawValue) }
    }
    
    var pairMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.pairMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.pairMaxScore.rawValue) }
    }
    
    var identificationMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.identificationMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.identificationMaxScore.rawValue) }
    }
    
    var puzzleMaxScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.puzzleMaxScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.puzzleMaxScore.rawValue) }
    }
    
    var totalScore: Int {
        get { userPreference.integer(forKey: PreferenceKey.totalScore.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.totalScore.rawValue) }
    }
    
    var userStep: Int {
        get { userPreference.integer(forKey: PreferenceKey.userStep.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.userStep.rawValue) }
    }
    
    var userExerciseTime: Int {
        get { userPreference.integer(forKey: PreferenceKey.userExerciseTime.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.userExerciseTime.rawValue) }
    }
    
    var finishInit: Bool {
        get { userPreference.bool(forKey: PreferenceKey.finishInit.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.finishInit.rawValue) }
    }
}

