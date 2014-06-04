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
	var body	: NSString
	var title	: NSString
	
	init(body: NSString?, title: NSString?)
	{
		self.body = (body) ? body! : "";
		self.title = (title) ? title! : "";
	}
	
	convenience init(fromObjcDictionary dictionary: NSDictionary)
	{
		var body 	=	dictionary.valueForKey("body") as? NSString
		var title	=	dictionary.valueForKey("title") as? NSString
		self.init(body: body, title: title)
	}
} 