//
//  File.swift
//  PFM
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import Charts

protocol ChartsDataProviderProtocol {
    func getMonthPieChartData(toMonth: Date) -> PieChartData
    func getLastDaysBarChartData(days: [Date]) -> BarChartData
    func getLastMonthsBarChartData(months: [Date]) -> BarChartData
}

final class DummyChartsDataProvider: ChartsDataProviderProtocol {
    
    func getMonthPieChartData(toMonth: Date) -> PieChartData {
        return PieChartData(dataSets: nil)
    }
    
    func getLastDaysBarChartData(days: [Date]) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, day) in days.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: getSumCostForDate(date: day))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Ez a felirat hova megy?")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        return chartData
    }
    
    func getLastMonthsBarChartData(months: [Date]) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, month) in months.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: getSumCostForMonth(month: month))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Ez a felirat hova megy?")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        return chartData
    }
    
    func getSumCostForDate(date: Date) -> Double {
        return [1000,2000,3000,4000,5000][Int(arc4random()%5)]
    }
    
    func getSumCostForMonth(month: Date) -> Double {
        return [100000,200000,150000,175000,90000][Int(arc4random()%5)]
    }
    
}
