//
//  UITableViewCell+MeetupOTown.swift
//  MeetUpOTown2
//
//  Created by Dean Thibault on 5/9/18.
//  Copyright © 2018 Digital Beans. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	static func reuseIdentifier() -> String {
		
		return String(describing: self)
	}
}
