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
        
        setupBarView(lastFewDaysBarChartView)
        setupBarView(lastFewMonthBarChartView)
        setupPieChart(currentMonthPieChartView)
    }
    
    private func setupBarView(_ barView: BarChartView) {
        
        // Barview
        barView.borderLineWidth = 0
        barView.drawBordersEnabled = false
        barView.drawGridBackgroundEnabled = false
        barView.borderColor = UIColor.clear
        barView.legend.enabled = false
        barView.chartDescription?.enabled = false
        barView.leftAxis.axisMinimum = 0.0
        barView.pinchZoomEnabled = false
        barView.doubleTapToZoomEnabled = false
        
        // Left axis
        barView.leftAxis.drawAxisLineEnabled = false
        barView.leftAxis.drawTopYLabelEntryEnabled = false
        barView.leftAxis.drawZeroLineEnabled = false
        barView.leftAxis.drawLimitLinesBehindDataEnabled = false
        barView.leftAxis.gridColor = UIColor.clear
        
        // Right axis
        barView.rightAxis.drawAxisLineEnabled = false
        barView.rightAxis.drawTopYLabelEntryEnabled = false
        barView.rightAxis.drawZeroLineEnabled = false
        barView.rightAxis.drawLimitLinesBehindDataEnabled = false
        barView.rightAxis.drawLabelsEnabled = false
        
        // Bottom X-axis
        let xAxis = barView.xAxis
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1.0
        //        xAxis.axisMinimum = 0.0
        if barView == lastFewMonthBarChartView {
            xAxis.valueFormatter = MonthsValueFormatter()
        } else {
            xAxis.valueFormatter = DaysValueFormatter()
        }
        xAxis.labelFont = UIFont.montserratLight(10.0)
        xAxis.labelWidth = 30.0
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.drawAxisLineEnabled = false
    }
    
    private func setupPieChart(_ pieChart: PieChartView) {
        pieChart.chartDescription?.enabled = false
    }
}

extension ChartsViewController: ChartsViewProtocol {
    
    func setCharts() {
        
    }
    
}

final class DaysValueFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let axis = axis {
            let max = Int(axis.axisMaximum)
            let value = Int(value)
            
            if let minDate = max.days.ago(),
                let valueDate = value.days.from(date: minDate) {
                if valueDate.isInSameDayOf(date: Date()) {
                    return "Today"
                }
                return valueDate.weekdayName
            }
        }
        return "\(value) d"
    }
}

final class MonthsValueFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let axis = axis {
            let max = Int(axis.axisMaximum)
            let value = Int(value)
            
            if let minDate = max.months.ago(),
                let valueDate = value.months.from(date: minDate) {
                return valueDate.monthName
            }
        }
        return "\(value) m"
    }
}

