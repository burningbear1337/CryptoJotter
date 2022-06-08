//
//  ColorScheme.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//


import UIKit
extension UIColor {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accentColor = UIColor(named: "AccentColor")
    let secondaryColor = UIColor(named: "SecondaryColor")
    let redColor = UIColor(named: "RedColor")
    let greenColor = UIColor(named: "GreenColor")
    let backgroundColor = UIColor(named: "BackgroundColor")
    let secondaryBackgroundColor = UIColor(named: "SecondaryBackgroundColor")
    let shadowColor = UIColor(named: "ShadowColor")
}
