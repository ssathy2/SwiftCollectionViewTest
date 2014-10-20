//
//  MockJSONReader.swift
//  TestSwiftApp
//
//  Created by Sidd Sathyam on 6/3/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

class MockJSONReader
{
	class func dictionaryFromJSON(fileName : String) -> NSDictionary?
	{
		let bundle : NSBundle = NSBundle.mainBundle()

		if countElements(fileName) == 0
		{
			println("ERROR: No JSON file name provided")
			// TODO: Figure out how to return an empty dictionary
			return nil
		}
		var filePath : String = bundle.pathForResource(fileName, ofType: "json")!
		if countElements(filePath) == 0
		{
			println("ERROR: Invalid JSON File Name")
			// TODO: Figure out how to return an empty dictionary
			return nil
		}

		var fileData : NSData = NSData.dataWithContentsOfFile(filePath, options: nil, error: nil)
		return NSJSONSerialization.JSONObjectWithData(fileData, options: nil, error: nil) as? NSDictionary
	}
}