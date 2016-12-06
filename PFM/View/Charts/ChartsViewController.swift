//
//  ChartsViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class ChartsViewController: UIViewController, PresentableView {
    
    private struct Colors {
        static let primaryChartColor = UIColor.red
        static let chartBGColor = UIColor.clear
        static let secoundaryChartColor = UIColor.green
        static let primaryLegendColor = UIColor.blue
        static let secoundaryLegendColor = UIColor.purple
    }
    
    var presenter: ChartsViewPresenterProtocol?
    var dataProvider: ChartsDataProviderProtocol!
    
    @IBOutlet weak var currentMonthPieChartView: PieChartView!
    @IBOutlet weak var lastFewDaysBarChartView: BarChartView!
    @IBOutlet weak var lastFewMonthBarChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartAppearances()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshMonthData()
    }
    
    @IBAction func navigateToInputButtonTouched(_ sender: AnyObject) {
        self.presenter?.navigateToInputScreen()
    }

    func refreshMonthData() {
        self.currentMonthPieChartView.data = dataProvider.getMonthPieChartData(toMonth: Date())
        
        if let day1 = (-3.days).fromNow(),
            let day2 = (-2.days).fromNow(),
            let day3 = (-1.days).fromNow() {
            self.lastFewDaysBarChartView.data = dataProvider.getLastDaysBarChartData(days: [day1, day2, day3, Date()])
        }
        
        if let month1 = (-2.months).fromNow(),
            let month2 = (-1.months).fromNow() {
            self.lastFewMonthBarChartView.data = dataProvider.getLastMonthsBarChartData(months: [month1, month2, Date()])
        }
    }
    
    func setupChartAppearances() {
        // TODO - Dani: design
        // storyboardban kurva sok mindent be lehet állítani, lehet elég onnan is 8==D ~~~ :-)
    }
}

extension ChartsViewController: ChartsViewProtocol {
    
    func setCharts() {
        
    }
    
}


