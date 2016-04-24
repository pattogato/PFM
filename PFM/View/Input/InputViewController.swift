//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import MBPullDownController

class InputViewController: UIViewController, PresentableView, InputViewProtocol {

    // Constants
    let kCategoryCollectionViewCellHeight: CGFloat = 75.0
    let kCategoryCollectionViewItemSpacing: CGFloat = 16.0
    let kCategoryCollectionViewMargin: CGFloat = 16.0
    let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
    
    // Properties
    @IBOutlet weak var amountLabel: UILabel!
    
    var transactionModel: TransactionModel?
    var presenter: InputViewPresenterProtocol?
    
    var categories = [CategoryModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // Outlets
    @IBOutlet weak var numberPadContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    weak var delegate: SwipeViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNumpad()
        self.setupUI()
        self.setupPulldownController()
        
        self.categories = MockDAL.mockCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event handlers
    
    @IBAction func chartsButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToCharts()
    }
    
    @IBAction func settingsButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToSettings()
    }
    
    func setupUI() {
        self.amountLabel.numberOfLines = 1
    }
    
    func setupPulldownController() {
        
    }
    
    func setupNumpad() {
        numpadViewController = NumpadViewController(nibName: "NumpadViewController", bundle: NSBundle.mainBundle())
        self.addChildViewController(numpadViewController)
        self.numpadViewController.view.frame = numberPadContainerView.bounds
        self.numberPadContainerView.addSubview(numpadViewController!.view)
        self.numpadViewController?.didMoveToParentViewController(self)
        numpadViewController.delegate = self
    }
    
    @IBAction func completeButtonTouched(sender: AnyObject) {
        if self.amountLabel.text != nil {
            self.presenter?.saveAmount(self.amountLabel.text!)
        }
    }
    
    
    @IBAction func changeKeyboardTypeButtonTouched(sender: AnyObject) {
        self.presenter?.toggleKeyboardType()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func setTransaction(transaction: TransactionModel) {
        self.transactionModel = transaction
    }
}

extension InputViewController: NumberPadDelegate {
    
    func numberPadDelegateComaPressed() {
        self.presenter?.enterComa()
    }
    
    func numberPadDelegateNumberPressed(number: Int) {
        self.presenter?.enterDigit(number)
    }
    
    func numberPadDelegateDeletePressed() {
        self.presenter?.deleteDigit()
    }
    
}

extension InputViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCollectionViewCell", forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionViewWidth = (collectionView.frame.width - ((2 * kCategoryCollectionViewMargin) + (3 * kCategoryCollectionViewItemSpacing))) / 4
        return CGSizeMake(collectionViewWidth, kCategoryCollectionViewCellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCategoryCollectionViewItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
}

