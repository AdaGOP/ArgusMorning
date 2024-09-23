//
//  ArgusTests.swift
//  ArgusTests
//
//  Created by David Gunawan on 17/09/24.
//

import Testing
import XCTest
@testable import Argus


struct ArgusTests {
    
    @Test
    func testPersistence() {
        let manager = ContactManager()
        guard let contact = Contact(name: "Alice", phoneNumber: "1234567890") else {
            Issue.record("Failed to initialize Contact")
            return
        }
        manager.addContact(contact)
        manager.saveContacts()
        
        let newManager = ContactManager()
        newManager.loadContacts()
        
        #expect(newManager.contacts.count == 1, "Contacts should be persisted between sessions.")
        #expect(newManager.contacts.first?.name == "Alice", "Contact name should be 'Alice'.")
    }
    
    @Test
    func testInternationalContactNames() {
        let manager = ContactManager()
        guard let contact = Contact(name: "张伟", phoneNumber: "1234567890") else {
            Issue.record("Failed to initialize Contact")
            return
        }
        manager.addContact(contact)
        #expect(manager.contacts.first?.name == "张伟", "Contact name should be '张伟'.")
    }
    
    
    @Test
    func testImportContactsWithInvalidData() {
        let manager = ContactManager()
        // Simulate importing contacts with one invalid contact
        let json = """
            [
                {"name": "Valid Contact", "phoneNumber": "1234567890"},
                {"name": "", "phoneNumber": "invalid"},
                {"name": "Another Valid Contact", "phoneNumber": "0987654321"}
            ]
            """
        let data = json.data(using: .utf8)!
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("contacts.json")
        try? data.write(to: tempURL)
        
        manager.importContacts(fromFile: tempURL)
        
        #expect(manager.contacts.count == 2, "Should have imported 2 valid contacts.")
        #expect(manager.contacts.contains(where: { $0.name == "Valid Contact" }), "Should contain 'Valid Contact'.")
        #expect(manager.contacts.contains(where: { $0.name == "Another Valid Contact" }), "Should contain 'Another Valid Contact'.")
    }
    
    
    @Test
    func testMemoryLeakInClosures() {
        weak var weakManager: ContactManager?
        autoreleasepool {
            let manager = ContactManager()
            weakManager = manager
            manager.performBatchUpdate {
                for i in 0..<1000 {
                    if let contact = Contact(name: "Contact \(i)", phoneNumber: String(format: "%010d", i)) {
                        manager.addContact(contact)
                    }
                }
            }
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        #expect(weakManager == nil, "ContactManager should have been deallocated.")
    }
    
    @Test
    func testMergeContactsWithoutDuplicates() {
        let manager1 = ContactManager()
        let manager2 = ContactManager()
        
        guard let contact1 = Contact(name: "Alice", phoneNumber: "1234567890"),
              let contact2 = Contact(name: "Bob", phoneNumber: "0987654321"),
              let contact3 = Contact(name: "Alice", phoneNumber: "1234567890") else {
            Issue.record("Failed to initialize Contact")
            return
        }
        
        manager1.addContact(contact1)
        manager2.addContact(contact2)
        manager2.addContact(contact3)
        
        manager1.mergeContacts(from: manager2)
        
        // Expecting duplicates to be removed, so count should be 2
        #expect(manager1.contacts.count == 2, "Merged contacts should not contain duplicates.")
        
        // Verify that there is only one Alice contact
        let aliceContacts = manager1.contacts.filter { $0.name == "Alice" && $0.phoneNumber == "1234567890" }
        #expect(aliceContacts.count == 1, "There should be only one entry for Alice.")
        
    }
}
