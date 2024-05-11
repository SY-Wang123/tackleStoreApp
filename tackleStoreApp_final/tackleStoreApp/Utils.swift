// Utils.swift
// tackleStoreApp
// Created by Shiyao Wang on 4/5/2024.

import Foundation
import SwiftUI

// Function to convert a hexadecimal value to a SwiftUI Color.
func kRGBFromHex(_ rgbValue: Int) -> Color {
    return kRGBFromHex(rgbValue, alpha: 1.0)  // Default alpha to 1 for full opacity if not specified.
}
// Overloaded function to convert a hexadecimal value and an alpha value to a SwiftUI Color.
func kRGBFromHex(_ rgbValue: Int, alpha: CGFloat) -> Color {
    return Color(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,  // Extracts the red component.
                 green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,   // Extracts the green component.
                 blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,             // Extracts the blue component.
                 opacity: alpha)                                         // Applies the alpha transparency.
}

// Extension on the String class to add custom functionalities.
extension String {
    
    // Validates if the string is a valid email format.
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"  // Regular expression for email validation.
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)  // Evaluates if the string matches the email pattern.
    }
    
    // Trims whitespace characters from both ends of the string.
    func converString() -> String {
        self.trimmingCharacters(in: .whitespaces)
    }
}
