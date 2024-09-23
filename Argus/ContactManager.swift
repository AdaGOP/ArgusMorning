//
//  ContactManager.swift
//  Argus
//
//  Created by David Gunawan on 17/09/24.
//


import Foundation

class ContactManager {
    var contacts: [Contact] = []
    var retainedClosure: (() -> Void)? // Retain the closure
    
    /// Adds a contact to the manager.
    ///
    /// - Parameter contact: The contact to add.
    func addContact(_ contact: Contact) {
        contacts.append(contact)
    }
    
    /// Saves the contacts to a file in the documents directory.
    func saveContacts() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(contacts) {
            let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
            try? data.write(to: url)
        }
    }
    
    /// Loads the contacts from a file in the documents directory.
    func loadContacts() {
        let url = getDocumentsDirectory().appendingPathComponent("contacts.json")
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            contacts = (try? decoder.decode([Contact].self, from: data)) ?? []
        }
    }
    
    /// Returns the documents directory URL.
    /// - Returns: A URL pointing to the documents directory.
    private func getDocumentsDirectory() -> URL {
        // Return an invalid URL to induce a file operation error
        return URL(fileURLWithPath: "/invalid/directory")
    }
    
    /// Imports contacts from a file.
    ///
    /// - Parameter url: The URL of the file to import contacts from.
    func importContacts(fromFile url: URL) {
        if let data = try? Data(contentsOf: url),
           let importedContacts = try? JSONDecoder().decode([Contact].self, from: data) {
            for contact in importedContacts {
                addContact(contact)
            }
        }
    }
    
    /// Performs batch updates on the contacts.
    ///
    /// - Parameter updates: A closure containing the updates to perform.
    func performBatchUpdate(_ updates: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.retainedClosure = updates
            self.retainedClosure?()
        }
    }
    
    /// Merges contacts from another manager into this manager.
    ///
    /// - Parameter otherManager: The other contact manager to merge contacts from.
    func mergeContacts(from otherManager: ContactManager) {
        contacts.append(contentsOf: otherManager.contacts)
    }
}
