//
//  ContactTableViewControllerTests.swift
//  MyContactsTests
//
//  Created by Dean Thibault on 5/23/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import XCTest
@testable import MyContacts

class ContactTableViewControllerTests: XCTestCase {
	
	var testVC: ContactTableViewController?
	
	let firstName = "John"
	let lastName = "Smith"
	let phone = "444-333-2222"
	let address1 = "123 1st St"
	let address2 = "#3"
	let city = "Orlando"
	let state = "FL"
	let zip = "33333"
	
    override func setUp() {
        super.setUp()
		
		testVC = ContactTableViewController(nibName: "ContactTableViewController", bundle: nil)
		testVC?.viewDidLoad()
		
		// remove all contacts for testing
		if let contacts = testVC?.fetchData() {
			for contact in contacts {
				testVC?.managedContext?.delete(contact)
			}
			save()
		}
    }
    
    override func tearDown() {
		
		// remove all contacts after testing
		if let contacts = testVC?.fetchData() {
			for contact in contacts {
				testVC?.managedContext?.delete(contact)
			}
			save()
		}
		
		super.tearDown()
    }
    
    func testContact() {
		
		guard let contact = testVC?.createContact() else {
			XCTFail("new contact not created")
			return
		}
		contact.firstName = firstName
		contact.lastName = lastName
		contact.phoneNumber = phone
		contact.address1 = address1
		contact.address2 = address2
		contact.city = city
		contact.state = state
		contact.zipCode = zip
		
		save()
		
		XCTAssertEqual(contact.firstName, firstName)
		XCTAssertEqual(contact.lastName, lastName)
		XCTAssertEqual(contact.phoneNumber, phone)
		XCTAssertEqual(contact.address1, address1)
		XCTAssertEqual(contact.address2, address2)
		XCTAssertEqual(contact.city, city)
		XCTAssertEqual(contact.state, state)
		XCTAssertEqual(contact.zipCode, zip)

		if let contacts = testVC?.fetchData() {
			XCTAssertEqual(contacts.count, 1)
			XCTAssertEqual(contacts[0].firstName, firstName)
		}
		else {
			XCTFail("unable to fetch contacts")
		}
		
		testVC?.managedContext?.delete(contact)
		save()

		if let contacts = testVC?.fetchData() {
			XCTAssertEqual(contacts.count, 0)
		}
		else {
			XCTFail("unable to fetch contacts")
		}

	}
	
	func save() {
		do {
			try testVC?.managedContext?.save()
		} catch  let error as NSError {
			print("Could not delete. \(error), \(error.userInfo)")
		}
	}
}
