//
//  Question.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/3/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

class Question
{
	var body	: NSString?
	var title	: NSString?
	var user	: User?
	
	init(body: NSString?, title: NSString?, user: User?)
	{
		self.body	= body
		self.title	= title
		self.user	= user
	}
	
	convenience init(fromObjcDictionary dictionary: NSDictionary)
	{
		var body			=	dictionary.valueForKey("body") as? NSString
		var title			=	dictionary.valueForKey("title") as? NSString
		
		var userDictionary	=	dictionary.valueForKey("owner") as? NSDictionary
		var user : User?
		if userDictionary
		{
			user = User(dictionary: userDictionary!) as? User
		}
		
		self.init(
			body: body,
			title: title,
			user: user
		)
	}
} 