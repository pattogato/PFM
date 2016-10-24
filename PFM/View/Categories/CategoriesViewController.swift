//
//  CategoriesViewController.swift
//  PFM
//
//  Created by Daniel Tombor on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

// TODO: PROTOKOLLOK

final class CategoriesViewController: UIViewController {
    
    // MARK: - Constants
    
    static let kNibName: String = "CategoriesViewController"
    
    fileprivate let kCategoryCollectionViewCellSize: CGSize = CGSize(width: 64, height: 80)
        
    fileprivate let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsets(top: 26, left: 20, bottom: 0, right: 20)
    
    fileprivate let kCategoryCellIdentifier: String = "CategoryCollectionViewCell"
        
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        categories = MockDAL.mockCategories()
        
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: kCategoryCellIdentifier)
        
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
    
    @IBAction func amountLabelTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - CollectionView DataSource & Delegate Methods

extension CategoriesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: kCategoryCellIdentifier,
            for: indexPath) as! CategoryCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return kCategoryCollectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}
