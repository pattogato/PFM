//
//  HistoryViewController.swift
//  PFM
//
//  Created by Daniel Tombor on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

// TODO: PROTOKOLLOK

final class HistoryViewController: UIViewController {
    
    // MARK: - Constants

    private struct Constants {
    
        static let HistoryCellIdentifier = "HistoryCollectionViewCell"
        
        static let HeaderCellIdentifier = "HistoryHeaderCollectionReusableView"
        
        static let CellHeight: CGFloat = 50.0
        
        static let HeaderHeight: CGFloat = 80.0
        
        static let SectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    // MARK: - Properties
    
    // TODO: Sorted Dictionary [Day/week/Month : [TransactionModel]]
    private var transactions = [TransactionModel]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - General Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.scrollToItemAtIndexPath(
            NSIndexPath(forItem: transactions.count-1, inSection: 0),
            atScrollPosition: .Bottom,
            animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - IBActions

    @IBAction func handleTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - UICollectionView Delegate & DataSource & Layout

extension HistoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            Constants.HistoryCellIdentifier,
            forIndexPath: indexPath) as? HistoryCollectionViewCell else {
                assertionFailure("Check your cells")
                return UICollectionViewCell()
        }
        
        cell.transaction = transactions[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.CellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:

            let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                      withReuseIdentifier: Constants.HeaderCellIdentifier,
                                                                      forIndexPath: indexPath)
                    as! HistoryHeaderCollectionReusableView
            
            headerView.date = NSDate()
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.HeaderHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            let sections = CGFloat(collectionView.numberOfSections())
            var contentHeight = sections * Constants.HeaderHeight
            contentHeight += sections * Constants.SectionInset.top + sections * Constants.SectionInset.bottom
            
            for i in 0..<Int(sections) {
                contentHeight += Constants.CellHeight * CGFloat(collectionView.numberOfItemsInSection(i))
            }
            
            let top = max(collectionView.bounds.height - contentHeight, Constants.SectionInset.top)
            
            var insets = Constants.SectionInset
            insets.top = top
            
            return insets
        }
        
        return Constants.SectionInset
    }
}