//
//  HistoryViewController.swift
//  PFM
//
//  Created by Bence Pattogató on 24/05/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit

// TODO: PROTOKOLLOK

final class HistoryViewController: UIViewController {
    
    // TODO: View protocol, presenter, adatok kiszervezése
    
    // MARK: - Constants
    
    var dataProvider: TransactionDataProviderProtocol!

    fileprivate struct Constants {
    
        static let HistoryCellIdentifier = "HistoryCollectionViewCell"
        
        static let HeaderCellIdentifier = "HistoryHeaderCollectionReusableView"
        
        static let CellHeight: CGFloat = 50.0
        
        static let HeaderHeight: CGFloat = 80.0
        
        static let SectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    // MARK: - Properties
    
    // TODO: Sorted Dictionary [Day/week/Month : [TransactionModel]]
    var transactions = [TransactionModel]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - General Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.transactions = Array(dataProvider.getAllTransactions(nil).sorted(byProperty: "date"))
        
        if transactions.count > 0 {
            collectionView.scrollToItem(
                at: IndexPath(item: transactions.count-1, section: 0),
                at: .bottom,
                animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - IBActions

    @IBAction func handleTap(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionView Delegate & DataSource & Layout

extension HistoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.HistoryCellIdentifier,
            for: indexPath) as? HistoryCollectionViewCell else {
                assertionFailure("Check your cells")
                return UICollectionViewCell()
        }
        
        cell.transaction = transactions[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.bounds.width)
        return CGSize(width: UIScreen.main.bounds.width, height: Constants.CellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:

            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: Constants.HeaderCellIdentifier,
                                                                      for: indexPath)
                    as! HistoryHeaderCollectionReusableView
            
            headerView.date = Date()
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: Constants.HeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            let sections = CGFloat(collectionView.numberOfSections)
            var contentHeight = sections * Constants.HeaderHeight
            contentHeight += sections * Constants.SectionInset.top + sections * Constants.SectionInset.bottom
            
            for i in 0..<Int(sections) {
                contentHeight += Constants.CellHeight * CGFloat(collectionView.numberOfItems(inSection: i))
            }
            
            // FIXME: Magic number
            let top = max(UIScreen.main.bounds.height - 50 - contentHeight, Constants.SectionInset.top)
            
            var insets = Constants.SectionInset
            insets.top = top
            
            return insets
        }
        
        return Constants.SectionInset
    }
}
