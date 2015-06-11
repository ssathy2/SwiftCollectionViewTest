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
	@IBOutlet var postProfileImage		: UIImageView?
	@IBOutlet var questionAuthor		: UILabel?
    @IBOutlet var questionTitle			: UILabel?
	
    override func prepareForReuse() {
        super.prepareForReuse()
        postProfileImage!.image = nil
    }
    
	func updateWithModel(question : Question)
	{
		if let user = question.user {
			self.questionAuthor!.text	= user.display_name! as String
            if user.profile_image != nil {
				self.postProfileImage!.setImageWithURL(user.profile_image)
			}
		}
		self.questionTitle!.text			= question.title as? String;
	}
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{
	@IBOutlet var searchBar : UISearchBar?
	@IBOutlet var collectionView : UICollectionView?
	var questions : Array<Question> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("viewTapped"))
		self.view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func viewTapped() {
		self.view.endEditing(true)
	}
	
	func setupQuestionsArrayWithModels(models : Array<NSDictionary>) {
        self.questions = models.map({dictionary in Question(fromObjcDictionary: dictionary )})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
		return self.questions.count
	}
	
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let q : Question = self.questions[indexPath.row]
		let cell : PostCell = collectionView.dequeueReusableCellWithReuseIdentifier(DDDCollectionViewCellIdentifier, forIndexPath: indexPath) as! PostCell
		cell.updateWithModel(q)
		return cell
	}
    
    // UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewBounds = collectionView.bounds.size
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        return CGSizeMake(viewBounds.width, flowLayout.itemSize.height)
    }
	
	// UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {  // called when text changes (including clear) 
		if searchText.characters.count > 0 {
			let services : StackOverflowLiveServices = StackOverflowLiveServices.sharedInstance() as! StackOverflowLiveServices;
			services.fetchSearchResults(searchText, page: 1, completionHandler: {
				(urlResponse: NSURLResponse!, questions: [Question]?, error: NSError!) -> Void in
                    self.questions = questions!
                    self.collectionView!.reloadData()
				})
		}
	}

	
}

