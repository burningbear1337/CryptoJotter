//
//  Converters.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 13.06.2022.
//

import Foundation

extension Double {
    
    private var fractionDigits2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 5
        return formatter
    }
    
    func convertToStringWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return fractionDigits2.string(from: number) ?? "n/a"
    }
    
    private var fractionDigits0: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    func converToStringWith0Decimals() -> String {
        let number = NSNumber(value: self)
        return fractionDigits0.string(from: number) ?? "n/a"
    }
}

extension String {
    
    var removeHTMLSymbols: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
