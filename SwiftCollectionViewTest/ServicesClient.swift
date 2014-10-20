//
//  ServicesClient.swift
//  SwiftCollectionViewTest
//
//  Created by sathyam on 10/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

class ServicesClient
{
    var requestToHandlerMap = Dictionary<NSUUID, IDURLResponseHandler>()
    var operationQueue      = NSOperationQueue()
    var baseURL : String
    var defaultParameters : Dictionary<String, String>?
    var handlerLock         = NSLock()
    
    init (baseURL: String, defaultParameters: Dictionary<String, String>?)
    {
        self.baseURL = baseURL
        self.defaultParameters = defaultParameters
    }
    
    func fetchImage(request: IDURLRequest!, handler: IDURLImageResponseHandler)
    {
        
    }
    
    func fetchDictionary(request: IDURLRequest!, handler: IDURLResponseHandler)
    {
        if self.safeSetHandlerMap(request.identifier, handler: handler) == false
        {
            return;
        }
        
        if self.defaultParameters != nil
        {
            request.appendURLParams(self.defaultParameters!)
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: self.operationQueue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var handler = self.requestToHandlerMap[request.identifier]
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
    
    // returns if the handler map was updated or not
    func safeSetHandlerMap(identifier: NSUUID, handler: IDURLResponseHandler) -> Bool
    {
        var updated : Bool = false
        self.handlerLock.lock()
        if self.requestToHandlerMap[identifier] != nil
        {
            updated = true;
            self.requestToHandlerMap[identifier] = handler
        }
        else
        {
            updated = false;
        }
        self.handlerLock.unlock()
        return updated;
    }
    
    func safeRemoveHandlerMap(identifier: NSUUID)
    {
        self.handlerLock.lock()
        self.requestToHandlerMap.removeValueForKey(identifier)
        self.handlerLock.unlock()
    }
}
