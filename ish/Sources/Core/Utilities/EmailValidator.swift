//
//  EmailValidator.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import Foundation

struct EmailValidator {
    static func validate(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
