//
//  LiveDataServices.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

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
//		let url = "\(self.baseURL)search?"
//        let urlParams = ["intitle" : query, "page" : page.description, "site" : "stackoverflow"]
//        let request : IDURLRequest = IDURLRequest.createRequest(HTTPMethod.GET, stringURL: url, urlParams: urlParams, headers: nil)
//        self.requestFetcher.fetchJSON(request) {
//            (responseDict: NSDictionary?, error: NSError?) -> Void in
//            let items : [NSDictionary]? = responseDict.valueForKey("items") as? [NSDictionary]
//            if items != nil
//            {
//                var questionsArr : Array<Question> = []
//                for item in items!
//                {
//                    questionsArr.append(Question(fromObjcDictionary: item))
//                }
//                handler(response, questionsArr, error)
//            }
//        });
	}
	func fetchImage(url: NSURL, completionHandler handler: IDURLImageResponseHandler){
        let request = IDURLRequest(URL: url)
        self.requestFetcher.fetchImage(request) { (innerClosure) -> Void in
            handler(innerClosure: innerClosure)
        }
	}
}