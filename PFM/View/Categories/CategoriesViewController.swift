//
//  CategoriesViewController.swift
//  PFM
//
//  Created by Bence Pattogató on 25/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

// TODO: PROTOKOLLOK

protocol CategoriesViewProtocol: class {
    var categories: [CategoryModel] { get set }
}

final class CategoriesViewController: UIViewController, CategoriesViewProtocol, CategoriesInteractionControllerProtocol {
    
    var presenter: CategoriesPresenterProtocol!
    
    // MARK: - Constants
    
    static let kNibName: String = "CategoriesViewController"
    
    fileprivate let kCategoryCollectionViewCellSize: CGSize = CGSize(width: 64, height: 80)
    
    fileprivate let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsets(top: 26, left: 20, bottom: 0, right: 20)
    
    fileprivate let kCategoryCellIdentifier: String = "CategoryCollectionViewCell"
    
    // MARK: - Properties
    
    var snapshot: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let new = snapshot else { return }
            view.insertSubview(new, at: 0)
        }
    }
    
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
        
        // TODO: Not very nice (should load from sb)
        if presenter == nil {
            presenter = UIApplication.resolve(
                CategoriesPresenterProtocol.self,
                argument: self as CategoriesViewProtocol
            )
        }
        
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: kCategoryCellIdentifier)
        
        categoriesContainerView.layer.cornerRadius = 16
        self.collectionView.reloadData()
    }
    
    //  MARK: - IBActions
    
    @IBAction func amountLabelTapped(_ sender: AnyObject) {
        close()
    }
    
    var panView: UIView {
        return cashLabel
    }
    
    func toggleCategories(open: Bool) {
        guard !open else { return }
        close()
    }
    
    private func close() {
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
        cell.category = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return kCategoryCollectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: -- Handle
    }
}
