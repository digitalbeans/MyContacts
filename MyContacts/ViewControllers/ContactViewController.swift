//
//  ContactViewController.swift
//  MyContacts
//
//  Created by Dean Thibault on 5/23/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var phoneTextView: UITextView!
	@IBOutlet var addressTextView: UITextView!
	@IBOutlet var scrollView: UIScrollView!
	
	var contact: Contact?
	var delegate: DataChangeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(doEdit(_:)))

		setupView()
    }
	
	func setupView() {
		
		guard let contact = contact else { return }
		
		var name = contact.firstName ?? ""
		let lastName = contact.lastName ?? ""
		
		if !name.isEmpty {
			name = "\(name) "
		}
		name = "\(name)\(lastName)\n"
		nameLabel.text = name
		
		phoneTextView.text = contact.phoneNumber
		
		var address = ""
		if let address1 = contact.address1 {
			address += "\(address1)\n"
		}
		if let address2 = contact.address2 {
			address += "\(address2)\n"
		}
		let city = contact.city ?? ""
		let state = contact.state ?? ""
		let zip = contact.zipCode ?? ""
		var cityStateZip = city
		if !cityStateZip.isEmpty && !state.isEmpty {
			cityStateZip += " "
		}
		cityStateZip += state
		if !cityStateZip.isEmpty && !zip.isEmpty {
			cityStateZip += " "
		}
		cityStateZip += zip
		
		address += cityStateZip
		
		addressTextView.text = address
	}
	
	@IBAction func doEdit(_ sender: Any) {
		
		let contactViewController = EditContactViewController(nibName: EditContactViewController.nibName(), bundle: nil)
		contactViewController.isEditing = true
		contactViewController.contact = contact
		contactViewController.delegate = self
		navigationController?.pushViewController(contactViewController, animated: true)
	}
}

extension ContactViewController: DataChangeProtocol {
	
	func dataChanged() {
		
		setupView()
		
		delegate?.dataChanged()
	}
}
