//
//  LiveDataServices.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

class IDURLRequest: NSMutableURLRequest
{
	var identifier : NSUUID = NSUUID()
}

class StackOverflowLiveServices: StackOverflowServices
{
	var jsonRequestToHandlerMap = Dictionary<NSUUID, ((NSURLResponse!, NSDictionary!, NSError!) -> Void)?>()
	var baseURL : String = "http://api.stackexchange.com/2.2/"
	var defaultParameters = ["site" : "stackoverflow"]
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