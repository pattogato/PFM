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
    
    // InputProtocol properties
    @IBOutlet weak var amountLabel: UILabel!
    weak var inputContentPresenter: InputContentPresenterProtocol?
    
    var transactionModel: TransactionModel?
    var presenter: InputViewPresenterProtocol?
    
    var categories = [CategoryModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputContentContainerView: UIView!
    
    
    // Properties
    var numpadViewController: NumpadViewController!
    
    weak var delegate: SwipeViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupPulldownController()
        
        self.categories = MockDAL.mockCategories()
        self.inputContentPresenter?.showContent(InputContentType.Keyboard, keyboardType: KeyboardType.Numeric)
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

    // IBActions
    
    @IBAction func completeButtonTouched(sender: AnyObject) {
        if self.amountLabel.text != nil {
            self.presenter?.saveAmount(self.amountLabel.text!)
        }
    }
    
    @IBAction func changeKeyboardTypeButtonTouched(sender: AnyObject) {
        self.presenter?.toggleKeyboardType()
    }
    
    @IBAction func cameraButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func locationButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func noteButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func timeButtonTouched(sender: UIButton) {
        if self.inputContentPresenter?.presentingType != InputContentType.DatePicker {
            self.inputContentPresenter?.showContent(InputContentType.DatePicker, keyboardType: nil)
        } else {
            self.inputContentPresenter?.showContent(InputContentType.Keyboard, keyboardType: nil)
        }
        
        sender.selected = !sender.selected
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let inputContentVC = segue.destinationViewController as? InputContentViewProtocol
            where segue.identifier == "InputContentContainerView" {
            
            self.inputContentPresenter = InputContentPresenter(view: inputContentVC)
            inputContentVC.presenter = self.inputContentPresenter
            inputContentVC.parentVC = self
        }
        
    }
    
    func setTransaction(transaction: TransactionModel) {
        self.transactionModel = transaction
    }
}


// Numpad delegate methods
extension InputViewController {
    
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

