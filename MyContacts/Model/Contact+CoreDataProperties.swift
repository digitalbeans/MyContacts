//
//  Contact+CoreDataProperties.swift
//  MyContacts
//
//  Created by Dean Thibault on 5/22/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: Constants.Entity.Contact)
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var contactId: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zipCode: String?
}
