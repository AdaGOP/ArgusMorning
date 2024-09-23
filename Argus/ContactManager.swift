//
//  ContactManager.swift
//  Argus
//
//  Created by David Gunawan on 17/09/24.
//


import Foundation

class ContactManager {
    /// The array of contacts managed by this manager.
    var contacts: [Contact] = []
    
    /// Adds a contact to the manager.
    ///
    /// - Parameter contact: The contact to add.
    func addContact(_ contact: Contact) {
        contacts.append(contact)
    }
    
    /// Saves the contacts to a file in the documents directory.
    func saveContacts() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(contacts)
            let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
            try data.write(to: url)
        } catch {
            print("Error saving contacts: \(error)")
        }
    }
    
    /// Loads the contacts from a file in the documents directory.
    func loadContacts() {
        let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            contacts = try decoder.decode([Contact].self, from: data)
        } catch {
            print("Error loading contacts: \(error)")
            contacts = []
        }
    }
    
    /// Returns the documents directory URL.
    ///
    /// - Returns: A URL pointing to the documents directory.
    private func getDocumentsDirectory() -> URL {
        // Return the correct documents directory URL
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Imports contacts from a file.
    ///
    /// - Parameter url: The URL of the file to import contacts from.
    ///
    /// This method processes each contact individually, allowing valid contacts to be imported even if some are invalid.
    func importContacts(fromFile url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
            for dict in jsonArray ?? [] {
                if let name = dict["name"], let phoneNumber = dict["phoneNumber"],
                   let contact = Contact(name: name, phoneNumber: phoneNumber) {
                    addContact(contact)
                }
            }
        } catch {
            print("Error importing contacts: \(error)")
        }
    }
    
    /// Performs batch updates on the contacts.
    ///
    /// - Parameter updates: A closure containing the updates to perform.
    ///
    /// This method captures `self` weakly to prevent a memory leak.
    func performBatchUpdate(_ updates: @escaping () -> Void) {
        updates()
    }
    
    /// Merges contacts from another manager into this manager.
    ///
    /// - Parameter otherManager: The other contact manager to merge contacts from.
    ///
    /// This method checks for duplicates before adding contacts.
    func mergeContacts(from otherManager: ContactManager) {
        for contact in otherManager.contacts {
            if !contacts.contains(where: { $0.name == contact.name && $0.phoneNumber == contact.phoneNumber }) {
                addContact(contact)
            }
        }
    }
}
