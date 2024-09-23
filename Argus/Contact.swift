//
//  Contact.swift
//  Argus
//
//  Created by David Gunawan on 17/09/24.
//


import Foundation

class Contact: Codable {
    var name: String
    var phoneNumber: String
    
    /// Initializes a new contact with the given name and phone number.
    ///
    /// - Parameters:
    ///   - name: The name of the contact.
    ///   - phoneNumber: The phone number of the contact.
    /// - Returns: An instance of `Contact` if the provided information is valid; otherwise, `nil`.
    ///
    /// The initializer validates the name and phone number. The name must not be empty and must consist
    /// of only Latin letters and spaces. The phone number must be exactly 10 digits.
    init?(name: String, phoneNumber: String) {
        // Updated name validation to allow Unicode letters, spaces, hyphens, and apostrophes
        let nameRegex = "^[\\p{L} '\\-]+$"
        guard !name.isEmpty,
              name.range(of: nameRegex, options: .regularExpression) != nil,
              Contact.isValidPhoneNumber(phoneNumber) else {
            return nil
        }
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    /// Validates the given phone number.
    ///
    /// - Parameter number: The phone number string to validate.
    /// - Returns: `true` if the phone number is valid; otherwise, `false`.
    ///
    /// The phone number is considered valid if it consists of exactly 10 digits.
    static func isValidPhoneNumber(_ number: String) -> Bool {
        // Phone number must be exactly 10 digits.
        let phoneRegex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: number)
    }
}
