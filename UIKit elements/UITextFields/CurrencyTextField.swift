//
//  CurrencyTextField.swift
//  Test Features
//
//  Created by Abu-Bakr Jabbarov on 4/2/20.
//  Copyright © 2020 Evolution System LTD. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    private var formatter: NumberFormatter? = nil
    private var currentString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFormatter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFormatter()
    }
    
    private func setupFormatter() {
        delegate = self
        
        formatter = NumberFormatter()
        formatter?.numberStyle = NumberFormatter.Style.currency
        formatter?.locale = Locale(identifier: "uz-UZ")
        formatter?.currencyDecimalSeparator = "."
        formatter?.maximumFractionDigits = 2
        formatter?.allowsFloats = true
        formatter?.currencySymbol = ""
    }
    
    func formatCurrency(string: String) {
        
        let numberFromField = NSString(string: currentString).doubleValue
        var formattedNumber = formatter?.string(from: NSNumber(value: numberFromField))
        
        if currentString.hasSuffix(".") {
            formattedNumber?.removeLast(4)
            formattedNumber?.append(".")
        } else if formattedNumber!.hasSuffix(".00 ") {
            formattedNumber?.removeLast(4)
        } else if formattedNumber!.hasSuffix("0 ") {
            formattedNumber?.removeLast(2)
        } else {
            formattedNumber?.removeLast()
        }
        
        text = formattedNumber
    }
}


extension CurrencyTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9", ".":
            if currentString.contains(".") {
                if string == "." {
                    return false
                } else {
                    let decimalPoint = currentString[currentString.range(of: ".")!.upperBound...]
                    if decimalPoint.count > 1 {
                        return false
                    }
                }
            }
            currentString += string
            print(currentString)
            formatCurrency(string: currentString)
        default:
            let array = Array(string)
            var currentStringArray = Array(currentString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(string: currentString)
            }
        }
        return false
    }
}
