//
//  User.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

//"owner": {
//	"reputation": 120,
//	"user_id": 926903,
//	"user_type": "registered",
//	"accept_rate": 41,
//	"profile_image": "https://www.gravatar.com/avatar/3f273eb7559833b9295324b28b007a73?s=128&d=identicon&r=PG",
//	"display_name": "aradhya",
//	"link": "http://stackoverflow.com/users/926903/aradhya"
//},

class User
{
	var reputation		: NSNumber?
	var user_id			: NSString?
	var user_type		: NSString?
	var accept_rate		: NSNumber?
	var profile_image	: NSURL?
	var display_name	: NSString?
	var link			: NSURL?
	
	init(reputation: NSNumber?, user_id: NSString?, user_type: NSString?, accept_rate: NSNumber?, profile_image: NSURL?, display_name: NSString?, link: NSURL?)
	{
		self.reputation		= reputation
		self.user_id		= user_id
		self.user_type		= user_type
		self.accept_rate	= accept_rate
		self.profile_image	= profile_image
		self.display_name	= display_name
		self.link			= link
	}
	
	convenience init(dictionary: NSDictionary)
	{
		var reputation	= dictionary.valueForKey("reputation") as? NSNumber
		var user_id		= dictionary.valueForKey("user_id") as? NSString
		var user_type	= dictionary.valueForKey("user_type") as? NSString
		var accept_rate = dictionary.valueForKey("accept_rate") as? NSNumber
		var profile_image = NSURL(string: dictionary.valueForKey("profile_image") as? String) as NSURL?
		var display_name = dictionary.valueForKey("display_name") as? NSString
		var link = NSURL(string: dictionary.valueForKey("link") as? String) as NSURL?
		
		self.init(
			reputation: reputation,
			user_id: user_id,
			user_type: user_type,
			accept_rate: accept_rate,
			profile_image: profile_image,
			display_name: display_name,
			link: link
		)
	}
	
}