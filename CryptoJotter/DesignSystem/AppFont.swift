//
//  AppFont.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

enum AppFont {
    
    case semibold17
    case semibold15
    case regular13
    
    var font: UIFont? {
        switch self {
        case .semibold17: return UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .semibold15: return UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .regular13: return UIFont.systemFont(ofSize: 13, weight: .regular) 
        }
    }
}
