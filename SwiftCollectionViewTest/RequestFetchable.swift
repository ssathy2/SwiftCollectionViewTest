//
//  RequestFetchable.swift
//  SwiftCollectionViewTest
//
//  Created by sathyam on 10/5/15.
//  Copyright © 2015 dotdotdot. All rights reserved.
//

import Foundation

protocol RequestFetchable {
    func fetchImage(request: IDURLRequest, handler: IDURLImageResponseHandler?)
    func fetchJSON(request: IDURLRequest, handler: IDURLJSONResponseHandler?)
}