//
//  UserPreferences.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

final class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let userPreference = UserDefaults()
    
    private init() {
        userPreference = UserDefaults.standard
    }
    
    enum PreferenceKey: String {
        
        case <#stringkey#>
        
        case <#boolkey#>
        
        case <#intkey#>
        
        case <#doublekey#>
        
        case <#floatkey#>
        
        case <#datakey#>
        
        case <#arraykey#>
        
        case <#dictionarykey#>
    }
    
    var <#stringkey#>: String {
        get { userPreference.string(forKey: PreferenceKey.<#stringkey#>.rawValue) ?? "" }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#stringkey#>.rawValue) }
    }
    
    var <#boolkey#>: Bool {
        get { userPreference.bool(forKey: PreferenceKey.<#boolkey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#boolkey#>.rawValue) }
    }
    
    
    var <#intkey#>: Int {
        get { userPreference.integer(forKey: PreferenceKey.<#intkey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#intkey#>.rawValue) }
    }
    
    var <#doublekey#>: Double {
        get { userPreference.double(forKey: PreferenceKey.<#doublekey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#doublekey#>.rawValue) }
    }
    
    var <#floatkey#>: Float {
        get { userPreference.float(forKey: PreferenceKey.<#floatkey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#floatkey#>.rawValue) }
    }
    
    var <#datakey#>: Data? {
        get { userPreference.data(forKey: PreferenceKey.<#datakey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#datakey#>.rawValue) }
    }
    
    var <#arraykey#>: [Any]? {
        get { userPreference.array(forKey: PreferenceKey.<#arraykey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#arraykey#>.rawValue) }
    }
    
    var <#dictionarykey#>: [String: Any]? {
        get { userPreference.dictionary(forKey: PreferenceKey.<#dictionarykey#>.rawValue) }
        set { userPreference.set(newValue, forKey: PreferenceKey.<#dictionarykey#>.rawValue) }
    }
}

