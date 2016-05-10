//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import MBPullDownController

final class InputViewController: UIViewController, PresentableView, InputViewProtocol {

    // Constants
    
    private let kCategoryCollectionViewCellSize: CGSize = CGSize(width: 64, height: 80)
    
    private let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsets(top: 26, left: 20, bottom: 0, right: 20)

    private let kCategoryCellIdentifier = "CategoryCollectionViewCell"
    
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
    
    @IBOutlet weak var categoriesContainerView: UIView!
    
    @IBOutlet weak var categoriesPullIndicator: UIView!
    
    @IBOutlet var categoryPanGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var categoryTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var menuButtons: [UIButton]!
    
    // Properties
    
    var numpadViewController: NumpadViewController!
    
    weak var delegate: SwipeViewControllerProtocol?
    
    var categoriesViewController: CategoriesViewController? = nil
    
    private let categoriesTransition = CategoriesTransition()
    
    // MARK: - General methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupPulldownController()
        
        categories = MockDAL.mockCategories()
        inputContentPresenter?.showContent(InputContentType.Keyboard, keyboardType: KeyboardType.Numeric)
        
        collectionView.registerNib(
            UINib(nibName: "CategoryCollectionViewCell", bundle: NSBundle.mainBundle()),
            forCellWithReuseIdentifier: kCategoryCellIdentifier)
        categoriesContainerView.layer.cornerRadius = 16
        
        categoriesPullIndicator.layer.cornerRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event handlers
    
    @IBAction func chartsButtonTouched(sender: AnyObject) {
        presenter?.navigateToCharts()
    }
    
    @IBAction func settingsButtonTouched(sender: AnyObject) {
        presenter?.navigateToSettings()
    }
    
    func setupUI() {
        amountLabel.numberOfLines = 1
    }
    
    func setupPulldownController() {
        
    }

    // IBActions
    
    @IBAction func completeButtonTouched(sender: AnyObject) {
        if amountLabel.text != nil {
            presenter?.saveAmount(self.amountLabel.text!)
        }
    }
    
    @IBAction func changeKeyboardTypeButtonTouched(sender: AnyObject) {
        presenter?.toggleKeyboardType()
    }
    
    @IBAction func cameraButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func locationButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func noteButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func timeButtonTouched(sender: UIButton) {
        if inputContentPresenter?.presentingType != InputContentType.DatePicker {
            inputContentPresenter?.showContent(InputContentType.DatePicker, keyboardType: nil)
        } else {
            inputContentPresenter?.showContent(InputContentType.Keyboard, keyboardType: nil)
        }
        
        sender.selected = !sender.selected
    }
    
    @IBAction func handleCategoryTap(sender: AnyObject) {
        openCategories()
    }
    
    @IBAction func handleCategoryPan(sender: AnyObject) {
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let inputContentVC = segue.destinationViewController as? InputContentViewProtocol
            where segue.identifier == "InputContentContainerView" {
            
            inputContentPresenter = InputContentPresenter(view: inputContentVC)
            inputContentVC.presenter = self.inputContentPresenter
            inputContentVC.parentVC = self
        }
    }
    
    func setTransaction(transaction: TransactionModel) {
        transactionModel = transaction
    }
}

// MARK: - Categories Open

extension InputViewController: UIViewControllerTransitioningDelegate {
    
    private func  openCategories() {
        
        let categoriesViewController = self.categoriesViewController ?? CategoriesViewController(
            nibName: CategoriesViewController.kNibName,
            bundle: NSBundle.mainBundle())
        
        categoriesViewController.categories = self.categories
        
        categoriesViewController.transitioningDelegate = self
        self.categoriesViewController = categoriesViewController

        presentViewController(categoriesViewController,
                              animated: true,
                              completion: nil)
        
    }
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let presented = presented as? CategoriesViewController {
            
            categoriesTransition.presenting = true
            return categoriesTransition
            
        } else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is CategoriesViewController {
        
            categoriesTransition.presenting = false
            return categoriesTransition
        
        } /* Else if history .. */
        else {
            return nil
        }
        
    }
    
}

// Numpad delegate methods

extension InputViewController {
    
    func numberPadDelegateComaPressed() {
        presenter?.enterComa()
    }
    
    func numberPadDelegateNumberPressed(number: Int) {
        presenter?.enterDigit(number)
    }
    
    func numberPadDelegateDeletePressed() {
        presenter?.deleteDigit()
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCategoryCellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return kCategoryCollectionViewCellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
}

