//
//  DictionaryExtensions.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

extension Dictionary
{
	func urlEncodedString() -> String {
        return "&".join(self.keys.map({key in "\(key)=\(self[key]!)"}))
	}
}