//
//  ServicesClient.swift
//  SwiftCollectionViewTest
//
//  Created by sathyam on 10/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

class ServicesClient
{
    var jsonRequestToHandlerMap = Dictionary<NSUUID, IDURLResponseHandler>()
    var imageRequestToHandlerMap = Dictionary<NSUUID, IDURLImageResponseHandler>()
    
    var operationQueue      = NSOperationQueue()
    var baseURL : String
    var defaultParameters : Dictionary<String, String>?
    var jsonResponseHandlerLock         = NSLock()
    var imageResponseHandlerLock        = NSLock()
    
    init (baseURL: String, defaultParameters: Dictionary<String, String>?) {
        self.baseURL = baseURL
        self.defaultParameters = defaultParameters
    }
    
    func fetchImage(request: IDURLRequest!, handler: IDURLImageResponseHandler) throws {
        guard safeSetImageHandlerMap(request.identifier, handler: handler) == true else {
            throw ServicesError.HandlerError
        }
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let handler = self.safeGetImageHandlerMap(request.identifier) {
                if (data != nil)
                {
                    let image : UIImage? = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue(), {
                        handler(response, image, error)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        handler(response, nil, error)
                    })
                }
            }
        }
        dataTask!.resume();
    }
    
    func fetchJSON(request: IDURLRequest!, handler: IDURLResponseHandler) throws {
        guard safeSetJSONHandlerMap(request.identifier, handler: handler) == true else {
            throw ServicesError.HandlerError
        }
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let handler = self.safeGetJSONHandlerMap(request.identifier) {
                do {
                    let convertedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    dispatch_async(dispatch_get_main_queue(), {
                        handler(response, convertedDictionary!, error)
                    })
                }
                catch let error {
                    print(error)
                    // do nothing
                }
            }
        }
        dataTask!.resume()
    }
    
    func safeGetJSONHandlerMap(identifier: NSUUID) -> IDURLResponseHandler
    {
        var responseHandler : IDURLResponseHandler?;
        if (jsonResponseHandlerLock.tryLock()) {
            responseHandler = self.jsonRequestToHandlerMap[identifier]
            self.jsonResponseHandlerLock.unlock()
        }
        return responseHandler
    }
    
    func safeGetImageHandlerMap(identifier: NSUUID) -> IDURLImageResponseHandler
    {
        var responseHandler :IDURLImageResponseHandler?;
        if (self.imageResponseHandlerLock.tryLock()) {
            responseHandler = self.imageRequestToHandlerMap[identifier]
            self.imageResponseHandlerLock.unlock()
        }
        return responseHandler
    }
   
    // returns if the json handler map was updated or not
    func safeSetJSONHandlerMap(identifier: NSUUID, handler: IDURLResponseHandler) -> Bool
    {
        var updated : Bool = false
        if (self.jsonResponseHandlerLock.tryLock())
        {
            if self.jsonRequestToHandlerMap[identifier] == nil
            {
                updated = true;
                self.jsonRequestToHandlerMap[identifier] = handler
            }
            else
            {
                updated = false;
            }
            self.jsonResponseHandlerLock.unlock()
        }
        return updated;
    }
    
    func safeRemoveJSONHandlerMap(identifier: NSUUID)
    {
        if (jsonResponseHandlerLock.tryLock())
        {
            jsonRequestToHandlerMap.removeValueForKey(identifier)
            jsonResponseHandlerLock.unlock()
        }
    }
    
    // returns if the image handler map was updated or not
    func safeSetImageHandlerMap(identifier: NSUUID, handler: IDURLImageResponseHandler) -> Bool
    {
        var updated : Bool = false
        if (self.imageResponseHandlerLock.tryLock())
        {
            if self.imageRequestToHandlerMap[identifier] == nil
            {
                updated = true;
                self.imageRequestToHandlerMap[identifier] = handler
            }
            else
            {
                updated = false;
            }
            self.imageResponseHandlerLock.unlock()
        }
        return updated;
    }
    
    func safeRemoveImageHandlerMap(identifier: NSUUID)
    {
        if (imageResponseHandlerLock.tryLock())
        {
            self.imageRequestToHandlerMap.removeValueForKey(identifier)
            self.imageResponseHandlerLock.unlock()
        }
    }
}
