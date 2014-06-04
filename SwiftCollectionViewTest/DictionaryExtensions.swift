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
	func urlEncodedString() -> String
	{
		var encodedString : String = ""
		var tempArray	  : Array<String> = []
		for key in self.keys
		{
			tempArray.append("\(key)=\(self[key])")
		}
		
		for var i = 0; i < tempArray.count; ++i
		{
			if i != tempArray.count-1
			{
				encodedString += "\(tempArray[i])&"
			}
		}
		encodedString += "\(tempArray[tempArray.count-1])"
		return encodedString
	}
}