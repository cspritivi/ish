//
//  PasswordValidator.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import Foundation

struct PasswordValidator {
    static func validate(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,32}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    static func getFailureReason(_ password: String) -> String {
        var reasons: [String] = []
        
        if password.count < 8 {
            reasons.append("at least 8 characters")
        }
        if password.count > 32 {
            reasons.append("maximum 32 characters")
        }
        if !password.contains(where: { $0.isUppercase }) {
            reasons.append("an uppercase letter")
        }
        if !password.contains(where: { $0.isLowercase }) {
            reasons.append("a lowercase letter")
        }
        if !password.contains(where: { $0.isNumber }) {
            reasons.append("a number")
        }
        if !password.contains(where: { "[@$!%*?&]".contains($0) }) {
            reasons.append("a special character")
        }
        
        return "Password must contain " + reasons.joined(separator: ", ")
        
        //TODO: The error message must have and before the last reason. Eg. Password must contain a lowercase letter, a number, and a special character
    }
}
