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
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // Properties
    var numpadViewController: NumpadViewController!
    var locationPickerPresenter: LocationPickerPresenterProtocol?
    
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
        self.presenter?.navigateToCharts()
    }
    @IBAction func settingsButtonTouched(sender: AnyObject) {
        self.presenter?.navigateToSettings()
    }
    
    // IBActions
    
    @IBAction func completeButtonTouched(sender: AnyObject) {
        if self.amountLabel.text != nil {
            self.presenter?.saveAmount(self.amountLabel.text!)
        }
        
        let amount = Double(amountLabel.text ?? "0")
        
        // TODO: set categories
        let category = CategoryModel()
        
        let transaction = TransactionInteractor.createTransaction(nameTextField.text ?? "Untitled expense", amount: amount ?? 0, currency: currencyButton.titleLabel?.text ?? "USD", category: category)
        
        self.presenter?.saveTransaction(transaction)
    }
    
    @IBAction func changeKeyboardTypeButtonTouched(sender: AnyObject) {
        self.presenter?.toggleKeyboardType()
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
        if self.inputContentPresenter?.presentingType != InputContentType.DatePicker {
            self.inputContentPresenter?.showContent(InputContentType.DatePicker, keyboardType: nil)
        } else {
            self.inputContentPresenter?.showContent(InputContentType.Keyboard, keyboardType: nil)
        }
        
        sender.selected = !sender.selected
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
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCollectionViewCell", forIndexPath: indexPath) as? CategoryCollectionViewCell {
            cell.model = categories[indexPath.item]
            
            return cell
        }
        
        return UICollectionViewCell()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

