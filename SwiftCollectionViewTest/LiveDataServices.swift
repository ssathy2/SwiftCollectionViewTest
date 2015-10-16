//
//  LiveDataServices.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit
import Argo

class StackOverflowLiveServices: StackOverflowServices {
    let baseURL = "http://api.stackexchange.com/2.2/"
    let requestFetcher: RequestFetcher = RequestFetcher(baseURL: "http://api.stackexchange.com/2.2/", defaultParameters: ["site" : "stackoverflow"])
    
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
        let request : IDURLRequest = IDURLRequest.createRequest(IDURLRequest.HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
        self.requestFetcher.fetchJSON(request) { (innerClosure) -> Void in
            do {
                var allItems : [Question] = Array<Question>()
                if let j: NSDictionary = try innerClosure() as NSDictionary? {
                    let items : [NSDictionary]? = j.valueForKey("items") as? [NSDictionary]
                    for item in items!
                    {
                        allItems.append(decode(item)!)
                    }
                }
                handler(innerClosure: { return allItems })
            } catch let error {
                handler(innerClosure: { throw error })
            }
        }
	}
	func fetchImage(url: NSURL, completionHandler handler: IDURLImageResponseHandler){
        let request = IDURLRequest(URL: url)
        self.requestFetcher.fetchImage(request) { (innerClosure) -> Void in
            handler(innerClosure: innerClosure)
        }
	}
}