//
//  ContactTableViewController.swift
//  MyContacts
//
//  Created by Dean Thibault on 5/22/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import UIKit
import CoreData

protocol DataChangeProtocol {
	func dataChanged()
}

class ContactTableViewController: UITableViewController {
	
	var contacts: [Contact] = [] {
		didSet {
			contacts = contacts.sorted {
				let first = $0.lastName ?? ""
				let second = $1.lastName ?? ""
				return first < second
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// register the contact table cell nib
		let nib = UINib.init(nibName: ContactTableViewCell.reuseIdentifier(), bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier())

		// setup navigation bar
		navigationItem.rightBarButtonItem = editButtonItem
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAddContact(_:)))
		
		navigationItem.title = Constants.title
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		fetchData()
	}
	
	var managedContext: NSManagedObjectContext? {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
		
		return appDelegate.persistentContainer.viewContext
	}
	// retrieve data from store
	func fetchData() {
		
		guard let managedContext = managedContext else { return }
		
		let fetchRequest = NSFetchRequest<Contact>(entityName: Constants.Entity.Contact)

		do {
			contacts = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	func createContact() -> Contact? {
		
		guard let managedContext = managedContext else { return nil }

		guard let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.Contact, in: managedContext) else { return nil}
		
		let contact = Contact(entity: entity, insertInto: managedContext)

		return contact
	}
	
	// delete a contact from store
	func deleteContact(contact: Contact) {
		
		guard let managedContext = managedContext else { return }

		managedContext.delete(contact)
		
		do {
			try managedContext.save()
		} catch  let error as NSError {
			print("Could not delete. \(error), \(error.userInfo)")
		}
	}

	// create a new contact and display the edit view
	@IBAction func doAddContact(_ sender: Any) {
		
		guard let contact = createContact() else { return }
		
		let contactViewController = EditContactViewController(nibName: EditContactViewController.nibName(), bundle: nil)
		contacts.append(contact)
		contactViewController.isEditing = true
		contactViewController.contact = contact
		contactViewController.delegate = self
		navigationController?.pushViewController(contactViewController, animated: true)
	}
	

	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return contacts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier(), for: indexPath)
		
		let contact = contacts[indexPath.row]
		var name = ""
		if let firstName = contact.firstName {
			name = "\(firstName) "
		}
		if let lastName = contact.lastName {
			name = "\(name)\(lastName)"
		}
		cell.textLabel?.text = name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			let contact = contacts[indexPath.row]
			contacts.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			deleteContact(contact: contact)
			if contacts.isEmpty {
				isEditing = false
			}
		}
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: false)

		let contactViewController = ContactViewController(nibName: ContactViewController.nibName(), bundle: nil)
		contactViewController.contact = contacts[indexPath.row]
		navigationController?.pushViewController(contactViewController, animated: true)
	}
}

// MARK: - DataChangeProtocol

extension ContactTableViewController: DataChangeProtocol {
	
	// reload the table when data has been changed
	func dataChanged() {
		
		tableView.reloadData()
	}
}
