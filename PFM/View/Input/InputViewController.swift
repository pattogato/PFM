//
//  InputViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 04/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import MBPullDownController

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


final class InputViewController: UIViewController, PresentableView, InputViewProtocol, AlertProtocol, RouterDependentProtocol, CategoriesInteractionControllerProtocol {

    // MARK: Dependencies
    var presenter: InputViewPresenterProtocol!
    var router: RouterProtocol!
    
    // MARK: - Constants
    
    fileprivate let kCategoryCollectionViewCellSize: CGSize = CGSize(width: 64, height: 80)
    
    fileprivate let kCategoryCollectionInsets: UIEdgeInsets = UIEdgeInsets(top: 26, left: 20, bottom: 0, right: 20)

    fileprivate let kCategoryCellIdentifier = "CategoryCollectionViewCell"
    
    // MARK: - InputProtocol properties
    
    @IBOutlet weak var amountLabel: UILabel!
    
    var transactionModel: TransactionModel?
    
    var categories = [CategoryModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var inputContentContainerView: UIView!
    
    @IBOutlet weak var currencyButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoriesContainerView: UIView!
    
    @IBOutlet weak var categoriesPullIndicator: UIView!
    
    @IBOutlet var categoryPanGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var categoryTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var menuButtons: [UIButton]!
    
    // MARK: - Properties
    
    var numpadViewController: NumpadViewController!
    
    var categoriesViewController: CategoriesViewController? = nil
    
    fileprivate let categoriesTransition = CategoriesTransition()
    
    fileprivate let historyTransition = HistoryTransition()
    
    fileprivate var keyboardHideTapGestureRecognizer: UITapGestureRecognizer?
    
    fileprivate var imageHelper: ImageHelper?
    
    // MARK: - General methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupPulldownController()
        
        _ = UIApplication.resolve(service: CategoriesManagerProtocol.self)
            .getCategories().then { (categories) -> Void in
                self.categories = categories
        }
        
        presenter.openNumberPad()
        
        collectionView.register(
            UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: kCategoryCellIdentifier)
        categoriesContainerView.layer.cornerRadius = 16
        
        categoriesPullIndicator.layer.cornerRadius = 2
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    

    func setupUI() {
        self.amountLabel.numberOfLines = 1
        self.amountLabel.adjustsFontSizeToFitWidth = true
        self.amountLabel.minimumScaleFactor = 0.3
    }
    
    func setupPulldownController() {
        
    }
    
    func showNoAmountError() {
        self.showAlert(title: "No amount", message: "Please enter an amount to save", cancel: "Understood")
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let inputContentVC = segue.destination as? InputContentViewProtocol {
            
            presenter.inputContentPresenter = inputContentVC.presenter
            inputContentVC.contentDelegate = self.presenter
        } else if let historyVc = segue.destination as? HistoryViewController {
            historyVc.transitioningDelegate = self
        } else if let noteView = segue.destination as? NoteViewProtocol {
            noteView.presenter.delegate = self.presenter
        }
    }
    
    func setTransaction(_ transaction: TransactionModel) {
        self.transactionModel = transaction
    }
    
 
}

// Button event handlers

extension InputViewController {
    // MARK: - Event handlers
    
    @IBAction func chartsButtonTouched(_ sender: AnyObject) {
        presenter.navigateToCharts()
    }
    
    @IBAction func settingsButtonTouched(_ sender: AnyObject) {
        presenter.navigateToSettings()
    }
    
    // IBActions
    
    @IBAction func changeKeyboardTypeButtonTouched(_ sender: AnyObject) {
        presenter.toggleKeyboardType()
    }
    
    @IBAction func cameraButtonTouched(_ sender: AnyObject) {
        if presenter.presentedContent == .image(image: nil) {
            self.presenter.openNumberPad()
        } else {
            self.presenter.openCameraScreen(forced: false)
        }
    }
    
    @IBAction func locationButtonTouched(_ sender: AnyObject) {
        self.presenter.openLocationScreen()
    }
    
    @IBAction func noteButtonTouched(_ sender: AnyObject) {
        presenter.openNoteScreen()
    }
    
    @IBAction func currencyButtonTouched(_ sender: AnyObject) {
        if presenter.presentedContent == .currencyPicker {
            presenter.openNumberPad()
        } else {
            presenter.changeCurrency()
        }
    }
    
    @IBAction func timeButtonTouched(_ sender: UIButton) {
        if presenter.presentedContent == .datePicker {
            presenter.openNumberPad()
        } else {
            presenter.changeDate()
        }
    }
    
    @IBAction func handleCategoryTap(_ sender: AnyObject) {
        openCategories()
    }
    
    @IBAction func handleCategoryPan(_ sender: AnyObject) {
        
    }
    
    var panView: UIView {
        return categoriesContainerView
    }
    
    func toggleCategories(open: Bool) {
        guard open else { return }
        openCategories()
    }

}

// Input view protocol methods
extension InputViewController {
    func openCamera() {
        imageHelper = ImageHelper()
        imageHelper?.showImagePickerWithSourceSelector(
            viewController: self,
            onPickerCancelled: nil,
            onPickerImageSelected: { (image) in
                self.presenter.saveImage(image)
                self.presenter.openCameraScreen(forced: false)
        })
    }
    
    func openNoteScreen() {
        self.performSegue(withIdentifier: "toNotesSegue", sender: nil)
    }
    
    func openLocationPicker() {
        // TODO: Implement
//        self.locationPickerPresenter = LocationPickerPresenter.presentLocationPicker(self)
    }
    
    func resetUI() {
        self.amountLabel.text = "0"
        self.nameTextField.text = ""
    }
    
    func appendAmountComa() {
        if let labelText = self.amountLabel.text {
            if !labelText.characters.contains(".") {
                if labelText.characters.count == 0 {
                    self.amountLabel.text!.append(Character("0"))
                } else if labelText == "0" {
                    self.amountLabel.text = "0."
                } else {
                    self.amountLabel.text!.append(Character("."))
                }
            }
            
        }
    }
    
    func appendAmountDigit(_ digit: Character) {
        if self.amountLabel.text != nil {
            if amountLabel.text! == "0" {
                self.amountLabel.text = "\(digit)"
            } else {
                self.amountLabel.text!.append(digit)
            }
        }
    }
    
    func deleteAmountDigit() {
        if let text = self.amountLabel.text {
            if self.amountLabel.text?.characters.count == 1 {
                self.amountLabel.text = "0"
            } else if self.amountLabel.text?.characters.count > 1 {
                self.amountLabel.text = String(text.characters.dropLast())
            }
        }
    }
}

// MARK: - Categories Open

extension InputViewController: UIViewControllerTransitioningDelegate {
    
    fileprivate func  openCategories() {
        
        let categoriesViewController = self.categoriesViewController ?? CategoriesViewController(
            nibName: CategoriesViewController.kNibName,
            bundle: Bundle.main)
        
        categoriesViewController.categories = self.categories
        
        categoriesViewController.transitioningDelegate = self
        self.categoriesViewController = categoriesViewController

        present(categoriesViewController,
                              animated: true,
                              completion: nil)
        
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = presented as? CategoriesViewController {
            
            categoriesTransition.presenting = true
            return categoriesTransition
            
        } else if let _ = presented as? HistoryViewController {
            historyTransition.presenting = true
            return historyTransition
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is CategoriesViewController {
        
            categoriesTransition.presenting = false
            return categoriesTransition
        
        }
        else if dismissed is HistoryViewController {
            
            historyTransition.presenting = false
            return historyTransition
            
        }
        return nil
        
    }
}

extension InputViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCategoryCellIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return kCategoryCollectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return kCategoryCollectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.saveCategory(categories[(indexPath as NSIndexPath).item])
    }
    
}

extension InputViewController: UITextFieldDelegate {
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if keyboardHideTapGestureRecognizer == nil {
            keyboardHideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
            self.view.addGestureRecognizer(keyboardHideTapGestureRecognizer!)
        }
        keyboardHideTapGestureRecognizer?.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardHideTapGestureRecognizer?.isEnabled = false
        self.presenter.saveName(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension InputViewController: LocationPickerDelegate {
    
    func locationPicked(_ lat: Double, lng: Double, venue: String?) {
        self.presenter.saveLocation(lat: lat, lng: lng, venue: venue)
    }
    
}

