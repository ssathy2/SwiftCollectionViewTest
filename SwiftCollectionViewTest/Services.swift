//
//  Services.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

enum HTTPMethod: Int
{
	case POST, GET, DELETE, OPTIONS
	func simpleDescription() -> String
	{
		switch self
		{
			case .POST:		return "POST"
			case .GET:		return "GET"
			case .DELETE:	return "DELETE"
			case .OPTIONS:	return "OPTIONS"
		}
	}
}

protocol StackOverflowServices
{
	var baseURL		: String {set get}
	func fetchSearchResults(query: String, page: Int, completionHandler handler: ((NSURLResponse!, NSDictionary!, NSError!) -> Void)!)
}