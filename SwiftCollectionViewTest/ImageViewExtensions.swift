//
//  ImageViewExtensions.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
	func setImageWithURL(url: NSURL!)
	{
		var services : StackOverflowLiveServices = StackOverflowLiveServices.sharedInstance() as StackOverflowLiveServices;
		var imageURLString = url.absoluteString;
		services.fetchImage(imageURLString, completionHandler: {
			(urlResponse: NSURLResponse!, image: UIImage!, error: NSError!) -> Void in
				// TODO: Probably need to run this on the main thread
				self.image = image;
			})
	}
}