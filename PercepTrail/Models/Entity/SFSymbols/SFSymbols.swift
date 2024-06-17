//
//  SFSymbols.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import UIKit

/// enum SFSymbols，App 中有使用到的原生 SF Symbols icon
/// - Tag: SFSymbols
public enum SFSymbols {
    
    /// SF Symbols icon 名稱：checkmark.square.fill
    case checked
    
    /// SF Symbols icon 名稱：square
    case unchecked
    
    /// SF Symbols icon 名稱：eye.fill
    case openEye
    
    /// SF Symbols icon 名稱：eye.slash.fill
    case closeEye
    
    /// SF Symbols icon 名稱：chevron.backward
    case back
    
    /// SF Symbols icon 名稱：checkmark
    case checkmark
    
    /// SF Symbols icon 名稱：plus
    case plus
    
    /// SF Symbols icon 名稱：lock.fill
    case lock
    
    /// SF Symbols icon 名稱：magnifyingglass
    case magnifyingglass
    
    /// SF Symbols icon 名稱：qrcode.viewfinder
    case qrcode
    
    /// SF Symbols icon 名稱：square.and.pencil
    case edit
    
    /// SF Symbols icon 名稱：trash.fill
    case trash
    
    /// SF Symbols icon 名稱：key.fill
    case key
    
    /// SF Symbols icon 名稱：note.text
    case notes
    
    /// SF Symbols icon 名稱：gear
    case settings
    
    /// SF Symbols icon 名稱：xmark
    case close
    
    /// SF Symbols icon 名稱：ellipsis
    case threeDot
    
    /// SF Symbols icon 名稱：sdcard.fill
    case save
    
    /// SF Symbols icon 名稱：square.and.arrow.up
    case share
        
    /// SF Symbols icon 名稱：info.circle.fill
    case info
    
    /// SF Symbols icon 名稱：faceid
    case faceid
    
    /// SF Symbols icon 名稱：touchid
    case touchid
    
    /// SF Symbols icon 名稱：arrow.forward.square.fill
    case rightChevronWithBackground
    
    /// SF Symbols icon 名稱：person
    case person

    /// SF Symbols icon 名稱：arrow.counterclockwise
    case arrowCounterclockwise
    
    public var imageName: UIImage {
        switch self {
        case .checked:
            return #imageLiteral(resourceName: "checkmark.square.fill")
            
        case .unchecked:
            return #imageLiteral(resourceName: "square")
        case .openEye:
            return #imageLiteral(resourceName: "eye.fill")
        case .closeEye:
            return #imageLiteral(resourceName: "eye.slash.fill")
        case .back:
            return #imageLiteral(resourceName: "chevron.backward")
        case .checkmark:
            return #imageLiteral(resourceName: "checkmark")
        case .plus:
            return #imageLiteral(resourceName: "plus")
        case .lock:
            return #imageLiteral(resourceName: "lock.fill")
        case .magnifyingglass:
            return #imageLiteral(resourceName: "square")
        case .qrcode:
            return #imageLiteral(resourceName: "qrcode.viewfinder")
        case .edit:
            return #imageLiteral(resourceName: "square.and.pencil")
        case .trash:
            return #imageLiteral(resourceName: "trash.fill")
        case .key:
            return #imageLiteral(resourceName: "key.fill")
        case .notes:
            return #imageLiteral(resourceName: "note.text")
        case .settings:
            return #imageLiteral(resourceName: "gear")
        case .close:
            return #imageLiteral(resourceName: "xmark")
        case .threeDot:
            return #imageLiteral(resourceName: "ellipsis")
        case .save:
            return #imageLiteral(resourceName: "sdcard.fill")
        case .share:
            return #imageLiteral(resourceName: "square.and.arrow.up")
        case .faceid:
            return #imageLiteral(resourceName: "faceid")
        case .touchid:
            return #imageLiteral(resourceName: "touchid")
        case .info:
            return #imageLiteral(resourceName: "info.circle.fill")
        case .rightChevronWithBackground:
            return #imageLiteral(resourceName: "arrow.forward.square.fill")
        case .person:
            return #imageLiteral(resourceName: "person")
        case .arrowCounterclockwise:
            return #imageLiteral(resourceName: "arrow.counterclockwise")
        }
    }
}
