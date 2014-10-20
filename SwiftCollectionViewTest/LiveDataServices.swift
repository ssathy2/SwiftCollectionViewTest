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
    
    class func createRequest(httpMethod: SwiftCollectionViewTest.HTTPMethod, stringURL: String, urlParams: Dictionary<String, String>?, headers: Dictionary<String, String>?) -> IDURLRequest!
    {
        var fullURL : String = ""
        var encodedParams : String = ""
        
        if urlParams != nil
        {
            encodedParams = urlParams!.urlEncodedString()
        }
        if countElements(encodedParams) != 0
        {
            fullURL = "\(stringURL)\(encodedParams)"
        }
        
        var request = IDURLRequest(URL: NSURL(string: fullURL))
        request.HTTPMethod = httpMethod.simpleDescription()
        return request
    }
    
    func appendURLParams(params: Dictionary<String, String>)
    {
        var requestURL = self.URL
        if (requestURL == nil)
        {
            return;
        }
        
        var requestURLString = requestURL!.absoluteString
        requestURLString = requestURLString!.stringByAppendingString(params.urlEncodedString())
        self.URL = NSURL(string: requestURLString!)
    }
}

class StackOverflowLiveServices: StackOverflowServices
{
	var jsonRequestToHandlerMap = Dictionary<NSUUID, IDURLResponseHandler>()
	var imageRequestToHandlerMap = Dictionary<NSUUID, IDURLImageResponseHandler>()
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
    
    func fetchData(request: IDURLRequest!, handler: IDURLResponseHandler)
    {
        if self.jsonRequestToHandlerMap[request.identifier] != nil
        {
            return;
        }
        else
        {
            self.jsonRequestToHandlerMap[request.identifier] = handler
        }
        request.appendURLParams(self.defaultParameters)
        
    }
	
	func fetchSearchResults(query: String, page: Int, completionHandler handler: IDURLResponseHandler)
	{
		var url = "\(baseURL)search?"
		var urlParams = ["intitle" : query, "page" : page.description]

        var request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
		
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
			(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
				var handler = self.jsonRequestToHandlerMap[request.identifier]
				if handler != nil
				{
					var convertedDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
					if convertedDictionary != nil
					{
						handler!(response, convertedDictionary!, error)
						self.jsonRequestToHandlerMap.removeValueForKey(request.identifier)
					}
				}
			}
		)
	}
	
	func fetchImage(imageURL: String, completionHandler handler: IDURLImageResponseHandler)
	{
		var image = self.urlToImageMapping[imageURL]
		if image != nil
		{
			handler(nil, image!, nil)
		}
		
		var request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: imageURL, urlParams: nil, headers: nil)
		if self.imageRequestToHandlerMap[request.identifier] == nil
		{
			self.imageRequestToHandlerMap[request.identifier] = handler
		}
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
			(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
				var handler = self.imageRequestToHandlerMap[request.identifier]
				if handler != nil
				{
					var convertedImage = UIImage(data: data) as UIImage?
                    if (convertedImage != nil)
					{
						self.urlToImageMapping.updateValue(convertedImage, forKey: imageURL)
						handler!(response, convertedImage, error)
						self.imageRequestToHandlerMap.removeValueForKey(request.identifier)
					}
				}
			})
	}
	
}