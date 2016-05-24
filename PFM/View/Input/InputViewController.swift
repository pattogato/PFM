//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import MBPullDownController
import ALCameraViewController

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
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoriesContainerView: UIView!
    
    @IBOutlet weak var categoriesPullIndicator: UIView!
    
    @IBOutlet var categoryPanGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var categoryTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var menuButtons: [UIButton]!
    
    // Properties
    
    var numpadViewController: NumpadViewController!
    var locationPickerPresenter: LocationPickerPresenterProtocol?
    
    weak var delegate: SwipeViewControllerProtocol?
    
    var categoriesViewController: CategoriesViewController? = nil
    
    private let categoriesTransition = CategoriesTransition()
    
    var keyboardHideTapGestureRecognizer: UITapGestureRecognizer?
    
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
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    

    func setupUI() {
        self.amountLabel.numberOfLines = 1
        self.amountLabel.adjustsFontSizeToFitWidth = true
        self.amountLabel.minimumScaleFactor = 0.3
    }
    
    func setupPulldownController() {
        
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let inputContentVC = segue.destinationViewController as? InputContentViewProtocol
            where segue.identifier == "InputContentContainerView" {
            
            self.inputContentPresenter = InputContentPresenter(view: inputContentVC)
            inputContentVC.presenter = self.inputContentPresenter
            inputContentVC.parentVC = self
            inputContentVC.delegate = self
        }
        
    }
    
    func setTransaction(transaction: TransactionModel) {
        self.transactionModel = transaction
    }
 
}

// Button event handlers

extension InputViewController {
    // MARK: - Event handlers
    
    @IBAction func chartsButtonTouched(sender: AnyObject) {
        presenter?.navigateToCharts()
    }
    
    @IBAction func settingsButtonTouched(sender: AnyObject) {
        presenter?.navigateToSettings()
    }
    
    // IBActions
    
    @IBAction func completeButtonTouched(sender: AnyObject) {
        if amountLabel.text != nil {
            presenter?.saveAmount(self.amountLabel.text!)
        }
        
        let amount = Double(amountLabel.text ?? "0")
        
        // TODO: set categories
        let category = CategoryModel()
        
        let transaction = TransactionInteractor.createTransaction(nameTextField.text ?? "Untitled expense", amount: amount ?? 0, currency: currencyButton.titleLabel?.text ?? "USD", category: category)
        
        self.presenter?.saveTransaction(transaction)
    }
    
    @IBAction func changeKeyboardTypeButtonTouched(sender: AnyObject) {
        presenter?.toggleKeyboardType()
    }
    
    @IBAction func cameraButtonTouched(sender: AnyObject) {
        self.presenter?.openCameraScreen()
    }
    
    @IBAction func locationButtonTouched(sender: AnyObject) {
        self.presenter?.openLocationScreen()
    }
    
    @IBAction func noteButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func currencyButtonTouched(sender: AnyObject) {
        self.presenter?.changeCurrency()
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
    
}

// Input view protocol methods
extension InputViewController {
    func openCamera() {
        let croppingEnabled = true
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { image in
            self.dismissViewControllerAnimated(true, completion: { 
                print("got image")
            })
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    func openLocationPicker() {
        self.locationPickerPresenter = LocationPickerPresenter.presentLocationPicker(self)
        
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.presenter?.categorySelected(categories[indexPath.item])
    }
    
}

extension InputViewController: InputContentDelegate {
    
    func currencySelected(string: String) {
        currencyButton.setTitle(string, forState: UIControlState.Normal)
    }
    
    func dateSelected(date: NSDate) {
        
    }
}

extension InputViewController: UITextFieldDelegate {
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if keyboardHideTapGestureRecognizer == nil {
            keyboardHideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
            self.view.addGestureRecognizer(keyboardHideTapGestureRecognizer!)
        }
        keyboardHideTapGestureRecognizer?.enabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        keyboardHideTapGestureRecognizer?.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

