//
//  ServicesClient.swift
//  SwiftCollectionViewTest
//
//  Created by sathyam on 10/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

typealias IDInnerURLRawDataHandler = () throws -> (response: NSURLResponse, data: NSData);
typealias IDURLRawDataHandler = IDInnerURLRawDataHandler -> Void;

class RequestFetcher : RequestFetchable {
    var handlerMap = Dictionary<String, IDURLRawDataHandler>()
    
    var operationQueue = NSOperationQueue()
    var baseURL : String
    var defaultParameters : Dictionary<String, String>?
    var jsonResponseHandlerLock         = NSLock()
    var imageResponseHandlerLock        = NSLock()
    
    init (baseURL: String, defaultParameters: Dictionary<String, String>?) {
        self.baseURL = baseURL
        self.defaultParameters = defaultParameters
    }
    
    func fetchRequest(request: IDURLRequest, handler: IDURLRawDataHandler) {
        let bool = safeSetHandlerMap(request.URL!, handler: handler);
        
        if (!bool) { return }
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print("Response: \(response!)")
            guard let data = data else { return }
            handler((error == nil) ? { return (response!, data) } : { throw error! } )
        }
        dataTask.resume();
    }
    
    func fetchJSON(request: IDURLRequest, handler: IDURLJSONResponseHandler?) {
        fetchRequest(request) { (innerHandler: IDInnerURLRawDataHandler) -> Void in
            do {
                let result = try innerHandler()
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(result.data, options: []) as! NSDictionary
                handler!(innerClosure: { return jsonResult })
            } catch let error {
                handler!(innerClosure: { throw error })
            }
        }
    }
    
    func fetchImage(request: IDURLRequest, handler: IDURLImageResponseHandler?) {
        fetchRequest(request) { (innerHandler: IDInnerURLRawDataHandler) -> Void in
            do {
                let result = try innerHandler()
                handler!(innerClosure: { return UIImage(data: result.data)! })
            }
            catch let error {
                handler!(innerClosure: { throw error })
            }
        }
    }
    
    func safeGetHandlerMap(url: NSURL) -> IDURLRawDataHandler? {
        var responseHandler : IDURLRawDataHandler?;
        if (jsonResponseHandlerLock.tryLock()) {
            responseHandler = self.handlerMap[url.absoluteString]
            self.jsonResponseHandlerLock.unlock()
        }
        return responseHandler
    }
    
    // returns if the handler map was updated or not
    func safeSetHandlerMap(url: NSURL, handler: IDURLRawDataHandler) -> Bool {
        var updated : Bool = false
        if (self.jsonResponseHandlerLock.tryLock())
        {
            if self.handlerMap[url.absoluteString] == nil
            {
                updated = true;
                self.handlerMap[url.absoluteString] = handler
            }
            else
            {
                updated = false;
            }
            self.jsonResponseHandlerLock.unlock()
        }
        return updated;
    }
}
