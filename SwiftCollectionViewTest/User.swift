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

struct User
{
	var reputation		: NSNumber?
	var user_id			: NSString?
	var user_type		: NSString?
	var accept_rate		: NSNumber?
	var profile_image	: NSURL?
	var display_name	: NSString?
	var link			: NSURL?
	
	init(dictionary: NSDictionary)
	{
		self.reputation	= dictionary.valueForKey("reputation") as? NSNumber
		self.user_id		= dictionary.valueForKey("user_id") as? NSString
		self.user_type	= dictionary.valueForKey("user_type") as? NSString
		self.accept_rate = dictionary.valueForKey("accept_rate") as? NSNumber
		self.display_name = dictionary.valueForKey("display_name") as? NSString
		
		if dictionary.valueForKey("profile_image")
		{
			self.profile_image = NSURL(string: dictionary.valueForKey("profile_image") as? String) as? NSURL
		}
		
		if dictionary.valueForKey("link")
		{
			self.link = NSURL(string: dictionary.valueForKey("link") as? String) as? NSURL
		}
	}
	
}