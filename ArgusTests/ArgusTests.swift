//
//  ArgusTests.swift
//  ArgusTests
//
//  Created by David Gunawan on 17/09/24.
//

import Testing
@testable import Argus


struct ArgusTests {
    
    @Test
    func testAddContactWithEmptyName() {
        let manager = ContactManager()
        let contact = Contact(name: "", phoneNumber: "1234567890")
        manager.addContact(contact)
        #expect(manager.contacts.count == 0, "Contact with empty name should not be added.")
    }
    
    @Test
    func testAddContactWithInvalidPhoneNumber() {
        let manager = ContactManager()
        let contact = Contact(name: "Alice", phoneNumber: "abcde12345")
        manager.addContact(contact)
        #expect(manager.contacts.count == 0, "Contact with invalid phone number should not be added.")
    }
    
    @Test
    func testPreventDuplicateContacts() {
        let manager = ContactManager()
        let contact = Contact(name: "Bob", phoneNumber: "1234567890")
        manager.addContact(contact)
        manager.addContact(contact)
        #expect(manager.contacts.count == 1, "Duplicate contacts should not be added.")
    }
    
    @Test
    func testRemoveSpecificContact() {
        let manager = ContactManager()
        let contact1 = Contact(name: "Charlie", phoneNumber: "1234567890")
        let contact2 = Contact(name: "Charlie", phoneNumber: "0987654321")
        manager.addContact(contact1)
        manager.addContact(contact2)
        manager.removeContact(contact2)
        #expect(manager.contacts.count == 1, "Only the specified contact should be removed.")
        #expect(manager.contacts.contains(where: { $0 === contact1 }), "The other contact should remain.")
    }
    
    @Test
    func testFindContactByPartialName() {
        let manager = ContactManager()
        let contact = Contact(name: "Danielle Smith", phoneNumber: "1234567890")
        manager.addContact(contact)
        let foundContact = manager.findContact(byName: "Danielle")
        #expect(foundContact != nil, "Should find contact by partial name.")
    }
    
    @Test
    func testUpdateContactDetails() {
        let manager = ContactManager()
        let contact1 = Contact(name: "Eve", phoneNumber: "1234567890")
        let contact2 = Contact(name: "Eve", phoneNumber: "0987654321")
        manager.addContact(contact1)
        manager.addContact(contact2)
        let newContact = Contact(name: "Evelyn", phoneNumber: "1112223333")
        manager.updateContact(contact2, withNewContact: newContact)
        #expect(manager.contacts[1].name == "Evelyn", "Contact should be updated with new details.")
        #expect(manager.contacts[0].name == "Eve", "Other contact should remain unchanged.")
    }
    
    @Test
    func testContactsSortedAscending() {
        let manager = ContactManager()
        let contactA = Contact(name: "Alice", phoneNumber: "1234567890")
        let contactB = Contact(name: "Bob", phoneNumber: "0987654321")
        manager.addContact(contactB)
        manager.addContact(contactA)
        manager.sortContacts()
        #expect(manager.contacts.first?.name == "Alice", "Contacts should be sorted in ascending order.")
    }
    
}
