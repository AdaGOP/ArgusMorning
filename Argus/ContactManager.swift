//
//  ContactManager.swift
//  Argus
//
//  Created by David Gunawan on 17/09/24.
//


import Foundation

class ContactManager {
    var contacts: [Contact] = []

    func addContact(_ contact: Contact) {
        contacts.append(contact)
    }

    func removeContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.name == contact.name }) {
            contacts.remove(at: index)
        }
    }

    func findContact(byName name: String) -> Contact? {
        return contacts.first(where: { $0.name == name })
    }

    func updateContact(_ contact: Contact, withNewContact newContact: Contact) {
        if let index = contacts.firstIndex(where: { $0.name == contact.name }) {
            contacts[index] = newContact
        }
    }

    func sortContacts() {
        contacts.sort(by: { $0.name > $1.name })
    }
}
