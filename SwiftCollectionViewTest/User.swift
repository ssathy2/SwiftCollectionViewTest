//
//  User.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/4/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Foundation
import Argo
import Curry

//"owner": {
//	"reputation": 120,
//	"user_id": 926903,
//	"user_type": "registered",
//	"accept_rate": 41,
//	"profile_image": "https://www.gravatar.com/avatar/3f273eb7559833b9295324b28b007a73?s=128&d=identicon&r=PG",
//	"display_name": "aradhya",
//	"link": "http://stackoverflow.com/users/926903/aradhya"
//},

struct User
{
	var user_id			: String
	var user_type		: String
	var profile_image	: String?
	var display_name	: String
	var link			: String?
}

extension User : Decodable {
    static func decode(j: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> j <| "user_id"
            <*> j <| "user_type"
            <*> j <|? "profile_image"
            <*> j <| "display_name"
            <*> j <|? "link"
    }
}