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
    
    init (baseURL: String, defaultParameters: Dictionary<String, String>?)
    {
        self.baseURL = baseURL
        self.defaultParameters = defaultParameters
    }
    
    func fetchImage(request: IDURLRequest!, handler: IDURLImageResponseHandler)
    {
        if (self.safeSetImageHandlerMap(request.identifier, handler: handler) == false)
        {
            return;
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: self.operationQueue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var handler = self.safeGetImageHandlerMap(request.identifier)
            if handler != nil
            {
                var image : UIImage? = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), {
                    handler!(response, image, error)
                })
            }
        })
    }
    
    func fetchJSON(request: IDURLRequest!, handler: IDURLResponseHandler)
    {
        if (self.safeSetJSONHandlerMap(request.identifier, handler: handler) == false)
        {
            // We can safely return here because the safeSet failed which means that the request for this identifier is already in flight
            // don't need to call the handler here just yet..
            return;
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: self.operationQueue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var handler = self.safeGetJSONHandlerMap(request.identifier)
            if handler != nil
            {
                var convertedDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if convertedDictionary != nil
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        handler!(response, convertedDictionary!, error)
                    })
                    
                }
            }
        })
    }
    
    func safeGetJSONHandlerMap(identifier: NSUUID) -> IDURLResponseHandler
    {
        var responseHandler : IDURLResponseHandler?;
        self.jsonResponseHandlerLock.lock()
        responseHandler = self.jsonRequestToHandlerMap[identifier]
        self.jsonResponseHandlerLock.unlock()
        return responseHandler
    }
    
    func safeGetImageHandlerMap(identifier: NSUUID) -> IDURLImageResponseHandler
    {
        var responseHandler : IDURLImageResponseHandler?;
        self.imageResponseHandlerLock.lock()
        responseHandler = self.imageRequestToHandlerMap[identifer]
        self.jsonResponseHandlerLock.unlock()
        return responseHandler
    }
   
    // returns if the json handler map was updated or not
    func safeSetJSONHandlerMap(identifier: NSUUID, handler: IDURLResponseHandler) -> Bool
    {
        var updated : Bool = false
        self.jsonResponseHandlerLock.lock()
        if self.jsonRequestToHandlerMap[identifier] != nil
        {
            updated = true;
            self.jsonRequestToHandlerMap[identifier] = handler
        }
        else
        {
            updated = false;
        }
        self.jsonResponseHandlerLock.unlock()
        return updated;
    }
    
    func safeRemoveJSONHandlerMap(identifier: NSUUID)
    {
        self.jsonResponseHandlerLock.lock()
        self.jsonRequestToHandlerMap.removeValueForKey(identifier)
        self.jsonResponseHandlerLock.unlock()
    }
    
    // returns if the image handler map was updated or not
    func safeSetImageHandlerMap(identifier: NSUUID, handler: IDURLImageResponseHandler) -> Bool
    {
        var updated : Bool = false
        self.imageResponseHandlerLock.lock()
        if self.imageRequestToHandlerMap[identifier] != nil
        {
            updated = true;
            self.imageRequestToHandlerMap[identifier] = handler
        }
        else
        {
            updated = false;
        }
        self.imageResponseHandlerLock.unlock()
        return updated;
    }
    
    func safeRemoveImageHandlerMap(identifier: NSUUID)
    {
        self.imageResponseHandlerLock.lock()
        self.imageRequestToHandlerMap.removeValueForKey(identifier)
        self.imageResponseHandlerLock.unlock()
    }
}
