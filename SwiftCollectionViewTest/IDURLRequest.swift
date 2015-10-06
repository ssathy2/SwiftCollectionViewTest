//
//  IDURLRequest.swift
//  SwiftCollectionViewTest
//
//  Created by sathyam on 10/5/15.
//  Copyright © 2015 dotdotdot. All rights reserved.
//

import Foundation

enum HTTPMethod
{
    case POST, GET, DELETE, OPTIONS
    func simpleDescription() -> String {
        switch self {
        case .POST:		return "POST"
        case .GET:		return "GET"
        case .DELETE:	return "DELETE"
        case .OPTIONS:	return "OPTIONS"
        }
    }
}

protocol NSMutableRequestHelpers {
    func appendURLParams(params: Dictionary<String, String>)
    func createRequest(method: HTTPMethod, endPoint: String, 
}

class IDURLRequest: NSMutableURLRequest {
    var identifier : NSUUID = NSUUID()
    
    class func createRequest(httpMethod: HTTPMethod, stringURL: String, urlParams: Dictionary<String, String>?, headers: Dictionary<String, String>?) -> IDURLRequest {
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