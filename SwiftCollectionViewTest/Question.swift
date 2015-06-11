//
//  Question.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/3/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

struct Question
{
	var body	: NSString?
	var title	: NSString?
	var user	: User?
	
	init(fromObjcDictionary dictionary: NSDictionary)
	{
		self.body			=	dictionary.valueForKey("body") as? NSString
		self.title			=	dictionary.valueForKey("title") as? NSString
		
        if let userDictionary = dictionary.valueForKey("owner") as? NSDictionary {
			self.user = User(dictionary: userDictionary)
        }
	}
}