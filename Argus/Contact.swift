//
//  Contact.swift
//  Argus
//
//  Created by David Gunawan on 17/09/24.
//


import Foundation

class Contact {
    var name: String
    var phoneNumber: String
    
    init?(name: String, phoneNumber: String) {
        guard !name.isEmpty, Contact.isValidPhoneNumber(phoneNumber) else {
            return nil
        }
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    static func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: number)
    }
}
