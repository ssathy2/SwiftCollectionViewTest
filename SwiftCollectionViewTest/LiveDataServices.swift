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
    var baseURL = "http://api.stackexchange.com/2.2/"
    var servicesClient : ServicesClient = ServicesClient(baseURL: "http://api.stackexchange.com/2.2/", defaultParameters: ["site" : "stackoverflow"])
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
    
    func fetchSearchResults(query: String, page: Int, completionHandler handler: IDQuestionsHandler)
	{
		var url = "\(baseURL)search?"
		var urlParams = ["intitle" : query, "page" : page.description]
        var request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
		
        self.servicesClient.fetchJSON(request, handler: {
            (response: NSURLResponse!, responseDict: NSDictionary!, error: NSError!) in
            
        });
	}
	
	func fetchImage(imageURL: String, completionHandler handler: IDURLImageResponseHandler)
	{
	
	}
	
}