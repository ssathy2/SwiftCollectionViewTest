//
//  Question.swift
//  SwiftCollectionViewTest
//
//  Created by Sidd Sathyam on 6/3/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import Argo
import Curry

struct Question {
	var body	: String?
	var title	: String?
	var owner	: User?
}

extension Question : Decodable {
    static func decode(json: JSON) -> Decoded<Question> {
        return curry(Question.init)
            <^> json <|? "body"
            <*> json <|? "title"
            <*> json <|? "owner"
    }
}