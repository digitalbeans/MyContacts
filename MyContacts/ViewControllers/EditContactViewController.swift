//
//  EditContactViewController
//  MyContacts
//
//  Created by Dean Thibault on 5/22/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import UIKit
import CoreData

class EditContactViewController: UIViewController {
	
	@IBOutlet var firstNameTextField: UITextField!
	@IBOutlet var lastNameTextField: UITextField!
	@IBOutlet var phoneNumberTextField: UITextField!
	@IBOutlet var address1TextField: UITextField!
	@IBOutlet var address2TextField: UITextField!
	@IBOutlet var cityTextField: UITextField!
	@IBOutlet var stateTextField: UITextField!
	@IBOutlet var zipCodeTextField: UITextField!
	@IBOutlet var textFields: [UITextField]!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var scrollView: UIScrollView!

	let saveButtonTitle = "Save"
	
	var delegate: DataChangeProtocol?
	
	var contact: Contact?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doSave(_:)))
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		setupView()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		save()
		super.viewWillDisappear(animated)
	}
	
	func setupView() {
		
		guard let contact = contact else { return }
		
		firstNameTextField.text = contact.firstName
		lastNameTextField.text = contact.lastName
		phoneNumberTextField.text = contact.phoneNumber
		address1TextField.text = contact.address1
		address2TextField.text = contact.address2
		cityTextField.text = contact.city
		stateTextField.text = contact.state
		zipCodeTextField.text = contact.zipCode
	}
	
	@IBAction func doSave(_ sender: Any) {
		
		save()
		navigationController?.popViewController(animated: true)
	}
	
	func saveData() {
		
		contact?.firstName = firstNameTextField.text
		contact?.lastName = lastNameTextField.text
		contact?.phoneNumber = phoneNumberTextField.text
		contact?.address1 = address1TextField.text
		contact?.address2 = address2TextField.text
		contact?.city = cityTextField.text
		contact?.state = stateTextField.text
		contact?.zipCode = zipCodeTextField.text
		
		delegate?.dataChanged()
	}

	func save() {
		
		guard let appDelegate =
			UIApplication.shared.delegate as? AppDelegate else {
				return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		saveData()
	
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillShow(notification:NSNotification){
		
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset:UIEdgeInsets = self.scrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height + 40
		scrollView.contentInset = contentInset
	}
	
	@objc func keyboardWillHide(notification:NSNotification){
		
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInset
	}
}
