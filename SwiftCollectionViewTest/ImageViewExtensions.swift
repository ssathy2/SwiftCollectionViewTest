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
	func setImageWithURL(url: NSURL)
	{
		let services : StackOverflowLiveServices = StackOverflowLiveServices.sharedInstance() as! StackOverflowLiveServices;
        services.fetchImage(url) { (innerClosure) -> Void in
            
        }
    }
}