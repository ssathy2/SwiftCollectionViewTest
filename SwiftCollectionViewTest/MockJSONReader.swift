//
//  MockJSONReader.swift
//  TestSwiftApp
//
//  Created by Sidd Sathyam on 6/3/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation

enum MockJSONReaderError : ErrorType {
    case FileNameError
    case FilePathError
    case FileDataError
    case FileSerializationError
}

class MockJSONReader {
	class func dictionaryFromJSON(fileName : String) throws -> NSDictionary? {
		let bundle = NSBundle.mainBundle()

        guard fileName.characters.count > 0 else {
            throw MockJSONReaderError.FileNameError
        }
        
        guard let filePath = bundle.pathForResource(fileName, ofType: "json") else {
            throw MockJSONReaderError.FilePathError
        }
        
        guard let fileData = NSData(contentsOfFile: filePath) else {
            throw MockJSONReaderError.FileDataError
        }
        
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            return dict
        }
        catch {
            throw MockJSONReaderError.FileSerializationError
        }
	}
}