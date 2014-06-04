//
//  ViewController.swift
//  TestSwiftApp
//
//  Created by Sidd Sathyam on 6/2/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

import UIKit

let DDDCollectionViewCellIdentifier = "DDDCollectionViewCellID"

class PostCell : UICollectionViewCell
{
	@IBOutlet var postProfileImage		: UIImageView
	@IBOutlet var containerView			: UIView
	@IBOutlet var questionAuthor		: UILabel
	@IBOutlet var questionDescription	: UILabel
	@IBOutlet var questionTitle			: UILabel
	
	func updateWithModel(question : Question)
	{
		if question.user
		{
			self.questionAuthor.text	= question.user!.display_name
		}
		self.questionDescription.text	= question.body;
		self.questionTitle.text			= question.title;
	}
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{
	@IBOutlet var searchBar : UISearchBar
	@IBOutlet var collectionView : UICollectionView
	var questions : Array<Question> = []
	var liveServices : StackOverflowLiveServices = StackOverflowLiveServices()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	
	}
	
	func setupQuestionsArrayWithModels(models : Array<NSDictionary>)
	{
		for model in models
		{
			var m = Question(fromObjcDictionary: model)
			self.questions.append(m)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// UICollectionViewDataSource
	func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
	{
		return self.questions.count
	}
	
	func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
	{
		var q : Question = self.questions[indexPath.row]
		var cell : PostCell = collectionView.dequeueReusableCellWithReuseIdentifier(DDDCollectionViewCellIdentifier, forIndexPath: indexPath) as PostCell
		cell.updateWithModel(q)
		return cell
	}
	
	// UISearchBarDelegate
	func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) // called when text changes (including clear)
	{
		if countElements(searchText!) > 0
		{
			self.liveServices.fetchSearchResults(searchText!, page: 1, completionHandler: {
				(urlResponse: NSURLResponse!, dictionary: NSDictionary!, error: NSError!) -> Void in
					var items : Array<NSDictionary>? = dictionary.valueForKey("items") as? Array<NSDictionary>
					if items
					{
						self.setupQuestionsArrayWithModels(items!)
						self.collectionView.reloadData()
					}
				})
		}
	}

	
}

