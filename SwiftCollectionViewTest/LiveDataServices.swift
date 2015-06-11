//
//  LiveDataServices.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

class IDURLRequest: NSMutableURLRequest {
	var identifier : NSUUID = NSUUID()
    
    class func createRequest(httpMethod: SwiftCollectionViewTest.HTTPMethod, stringURL: String, urlParams: Dictionary<String, String>?, headers: Dictionary<String, String>?) -> IDURLRequest {
        var fullURL = stringURL
        var encodedParams = ""
        
        if urlParams != nil {
            encodedParams = urlParams!.urlEncodedString()
        }
        if encodedParams.characters.count != 0 {
            fullURL = "\(stringURL)\(encodedParams)"
        }
        
        let request = IDURLRequest(URL: NSURL(string: fullURL)!)
        request.HTTPMethod = httpMethod.simpleDescription()
        return request
    }
    
    func appendURLParams(params: Dictionary<String, String>) {
        var requestURLString = URL!.absoluteString
        requestURLString = requestURLString.stringByAppendingString(params.urlEncodedString())
        URL = NSURL(string: requestURLString)
    }
}

class StackOverflowLiveServices: StackOverflowServices {
    let baseURL = "http://api.stackexchange.com/2.2/"
    let servicesClient : ServicesClient = ServicesClient(baseURL: "http://api.stackexchange.com/2.2/", defaultParameters: ["site" : "stackoverflow"])
	class func sharedInstance() -> AnyObject {
		struct Static {
			static var sharedManager: StackOverflowLiveServices? = nil
			static var onceToken: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.onceToken, {
			Static.sharedManager = StackOverflowLiveServices()
		})
		return Static.sharedManager!
	}
    
    func fetchSearchResults(query: String, page: Int, completionHandler handler: IDQuestionsHandler) {
		let url = "\(self.baseURL)search?"
        let urlParams = ["intitle" : query, "page" : page.description, "site" : "stackoverflow"]
        let request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
        do {
            try self.servicesClient.fetchJSON(request, handler: {
                (response: NSURLResponse!, responseDict: NSDictionary!, error: NSError!) in
                let items : [NSDictionary]? = responseDict.valueForKey("items") as? [NSDictionary]
                if items != nil
                {
                    var questionsArr : Array<Question> = []
                    for item in items!
                    {
                        questionsArr.append(Question(fromObjcDictionary: item))
                    }
                    handler(response, questionsArr, error)
                }
            });
        }
        catch {
            print(error)
        }
	}
	
	func fetchImage(imageURL: String, completionHandler handler: IDURLImageResponseHandler){
        let request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: imageURL, urlParams: nil, headers: nil)
        do {
            try self.servicesClient.fetchImage(request, handler: handler)
        }
        catch {
            print(error)
        }
        
	}
	
}