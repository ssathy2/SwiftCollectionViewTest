//
//  Services.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

typealias IDURLJSONResponseHandler  = (innerClosure: () throws -> (NSDictionary)) -> Void;
typealias IDURLImageResponseHandler = (innerClosure: () throws -> (UIImage)) -> Void;
typealias IDQuestionsHandler        = (innerClosure: () throws -> ([Question])) -> Void;

protocol StackOverflowServices
{
	static func sharedInstance() -> AnyObject
	func fetchSearchResults(query: String, page: Int, completionHandler handler: IDQuestionsHandler)
	func fetchImage(url: NSURL, completionHandler handler: IDURLImageResponseHandler)
}
