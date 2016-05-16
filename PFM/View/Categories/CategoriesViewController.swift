//
//  CategoriesViewController.swift
//  PFM
//
//  Created by Daniel Tombor on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Constants
    
    static let kNibName: String = "CategoriesViewController"
    
    private let kCategoryCollectionViewCellSize: CGSize = CGSize(width: 64, height: 80)
        
    private let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsets(top: 26, left: 20, bottom: 0, right: 20)
    
    private let kCategoryCellIdentifier: String = "CategoryCollectionViewCell"
        
    // MARK: - Properties
    
    var categories = [CategoryModel]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categoriesContainerView: UIView!
        
    // MARK: - General Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .OverFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .OverFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        categories = MockDAL.mockCategories()
        
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: kCategoryCellIdentifier)
        
        categoriesContainerView.layer.cornerRadius = 16
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //  MARK: - IBActions
    
    @IBAction func amountLabelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - CollectionView DataSource & Delegate Methods

extension CategoriesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            kCategoryCellIdentifier,
            forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return kCategoryCollectionViewCellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}