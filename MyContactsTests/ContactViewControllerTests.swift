//
//  ContactViewControllerTests.swift
//  MyContactsTests
//
//  Created by Dean Thibault on 5/23/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import XCTest
@testable import MyContacts

class ContactViewControllerTests: XCTestCase {
	
	var testVC: ContactViewController?
	var tableVC: ContactTableViewController?

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

		testVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
		tableVC = ContactTableViewController(nibName: "ContactTableViewController", bundle: nil)
		tableVC?.viewDidLoad()
		
		guard let contact = tableVC?.createContact() else {
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

		testVC?.contact = contact
		testVC?.loadView()
		testVC?.viewDidLoad()
	}
    
	override func tearDown() {
		
		// remove all contacts after testing
		if let contacts = tableVC?.fetchData() {
			for contact in contacts {
				tableVC?.managedContext?.delete(contact)
			}
			save()
		}
		
		super.tearDown()
	}

    func testContactVC() {
		
		XCTAssertNotNil(testVC?.nameLabel)
		XCTAssertNotNil(testVC?.phoneTextView)
		XCTAssertNotNil(testVC?.addressTextView)
    }
	
	func testContactVCContact() {
		
		XCTAssertTrue(testVC?.nameLabel.text?.contains(firstName) ?? false)
		XCTAssertTrue(testVC?.nameLabel.text?.contains(lastName) ?? false)
		XCTAssertTrue(testVC?.phoneTextView.text?.contains(phone) ?? false)
		XCTAssertTrue(testVC?.addressTextView.text?.contains(address1) ?? false)
		XCTAssertTrue(testVC?.addressTextView.text?.contains(address2) ?? false)
		XCTAssertTrue(testVC?.addressTextView.text?.contains(city) ?? false)
		XCTAssertTrue(testVC?.addressTextView.text?.contains(state) ?? false)
		XCTAssertTrue(testVC?.addressTextView.text?.contains(zip) ?? false)
	}
	
	func save() {
		do {
			try tableVC?.managedContext?.save()
		} catch  let error as NSError {
			print("Could not delete. \(error), \(error.userInfo)")
		}
	}
}
