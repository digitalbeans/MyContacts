//
//  Contact.swift
//  Contacts
//
//  Created by Dean Thibault on 5/21/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import Foundation

class ContactOld {
	
	var contactId: String?
	var firstName: String?
	var lastName: String?
	var phoneNumber: String?
	var streetAddress1: String?
	var streetAddress2: String?
	var city: String?
	var state: String?
	var zipCode: String?

	init(contactId: String? = NSUUID().uuidString) {
		
		self.contactId = contactId
	}
	
	init(contactId: String? = NSUUID().uuidString, firstName: String, lastName: String) {
		
		self.contactId = contactId
		self.firstName = firstName
		self.lastName = lastName
	}

	func toJSON() -> [String: String] {
	
		var json: [String: String] = [:]
 		json["contactId"] = contactId
		json["firstName"] = firstName
		json["lastName"] = lastName
		json["phoneNumber"] = phoneNumber
		json["streetAddress1"] = streetAddress1
		json["streetAddress2"] = streetAddress2
		json["city"] = city
		json["state"] = state
		json["zipCode"] = zipCode
	
		return json
	}
}
