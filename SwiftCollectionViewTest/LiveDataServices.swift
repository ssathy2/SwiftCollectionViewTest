//
//  LiveDataServices.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

class IDURLRequest: NSMutableURLRequest
{
	var identifier : NSUUID = NSUUID()
}

class StackOverflowLiveServices: StackOverflowServices
{
	var jsonRequestToHandlerMap = Dictionary<NSUUID, ((NSURLResponse!, NSDictionary!, NSError!) -> Void)?>()
	var imageRequestToHandlerMap = Dictionary<NSUUID, ((NSURLResponse!, UIImage!, NSError!) -> Void)?>()
	var urlToImageMapping = Dictionary<String, UIImage?>()
	
	var baseURL : String = "http://api.stackexchange.com/2.2/"
	var defaultParameters = ["site" : "stackoverflow"]
	
	class func sharedInstance() -> AnyObject
	{
		struct Static {
			static var sharedManager: StackOverflowLiveServices? = nil
			static var onceToken: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.onceToken, {
			Static.sharedManager = StackOverflowLiveServices()
		})
		return Static.sharedManager!
	}
	
	func fetchSearchResults(query: String, page: Int, completionHandler handler: ((NSURLResponse!, NSDictionary!, NSError!) -> Void)!)
	{
		var url = "\(baseURL)search?"
		var urlParams = ["intitle" : query, "page" : page.description]
		var request : IDURLRequest = self.generateRequest(HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
		
		if !self.jsonRequestToHandlerMap[request.identifier]
		{
			self.jsonRequestToHandlerMap[request.identifier] = handler;
		}
		
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
			(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
				var handler = self.jsonRequestToHandlerMap[request.identifier]
				if handler
				{
					var convertedDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
					if convertedDictionary
					{
						handler!!(response, convertedDictionary!, error)
						self.jsonRequestToHandlerMap.removeValueForKey(request.identifier)
					}
				}
			}
		)
	}
	
	func fetchImage(imageURL: String, completionHandler handler: ((NSURLResponse!, UIImage!, NSError!) -> Void)!)
	{
		var image = self.urlToImageMapping[imageURL]
		if image
		{
			handler(nil, image!, nil)
		}
		
		var request : IDURLRequest = self.generateRequest(HTTPMethod.GET, stringURL: imageURL, urlParams: nil, headers: nil)
		if !self.imageRequestToHandlerMap[request.identifier]
		{
			self.imageRequestToHandlerMap[request.identifier] = handler
		}
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
			(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
				var handler = self.imageRequestToHandlerMap[request.identifier]
				if handler
				{
					var convertedImage = UIImage(data: data) as? UIImage
					if convertedImage
					{
						self.urlToImageMapping.updateValue(convertedImage!, forKey: imageURL)
						handler!!(response, convertedImage, error)
						self.imageRequestToHandlerMap.removeValueForKey(request.identifier)
					}
				}
			})
	}
	
	func generateRequest(httpMethod: HTTPMethod, stringURL: String, urlParams: Dictionary<String, String>?, headers: Dictionary<String, String>?) -> IDURLRequest
	{
		var fullURL : String = ""
		var encodedParams : String = ""
		var defaultEncodedParams : String = self.defaultParameters.urlEncodedString()
		
		if urlParams
		{
			encodedParams = urlParams!.urlEncodedString()
		}
		encodedParams = "\(encodedParams)&\(defaultEncodedParams)"
		if countElements(encodedParams) != 0
		{
			fullURL = "\(stringURL)\(encodedParams)"
		}
		
		var request = IDURLRequest(URL: NSURL(string: fullURL))
		request.HTTPMethod = httpMethod.simpleDescription()
		return request
	}
	
}