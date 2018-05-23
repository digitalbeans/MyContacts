//
//  EditContactViewControllerTests.swift
//  MyContactsTests
//
//  Created by Dean Thibault on 5/23/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import XCTest
@testable import MyContacts

class EditContactViewControllerTests: XCTestCase {
    
	var testVC: EditContactViewController?
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
		
		testVC = EditContactViewController(nibName: "EditContactViewController", bundle: nil)
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
		
		XCTAssertNotNil(testVC?.firstNameTextField)
		XCTAssertNotNil(testVC?.lastNameTextField)
		XCTAssertNotNil(testVC?.phoneNumberTextField)
		XCTAssertNotNil(testVC?.address1TextField)
		XCTAssertNotNil(testVC?.address2TextField)
		XCTAssertNotNil(testVC?.cityTextField)
		XCTAssertNotNil(testVC?.stateTextField)
		XCTAssertNotNil(testVC?.zipCodeTextField)
	}
	
	func testContactVCContact() {
		
		XCTAssertEqual(testVC?.firstNameTextField.text, firstName)
		XCTAssertEqual(testVC?.lastNameTextField.text, lastName)
		XCTAssertEqual(testVC?.phoneNumberTextField.text, phone)
		XCTAssertEqual(testVC?.address1TextField.text, address1)
		XCTAssertEqual(testVC?.address2TextField.text, address2)
		XCTAssertEqual(testVC?.cityTextField.text, city)
		XCTAssertEqual(testVC?.stateTextField.text, state)
		XCTAssertEqual(testVC?.zipCodeTextField.text, zip)
	}
	
	func save() {
		do {
			try tableVC?.managedContext?.save()
		} catch  let error as NSError {
			print("Could not delete. \(error), \(error.userInfo)")
		}
	}
}
