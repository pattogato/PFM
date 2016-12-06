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
        var dataEntries: [PieChartDataEntry] = []
      
        for (category, cost) in getCostsByCategoryForDate(date: toMonth) {
            let dataEntry = PieChartDataEntry(value: cost, label: category.name)
            dataEntries.append(dataEntry)
        }
        
        // TODO - Dani: design
        let colors = [UIColor.red, UIColor.blue, UIColor.green]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = colors
        
        return chartData
    }
    
    func getLastDaysBarChartData(days: [Date]) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, day) in days.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: getSumCostForDate(date: day))
            dataEntries.append(dataEntry)
        }
        // TODO - Dani: design
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
        // TODO - Dani: design
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Ez a felirat hova megy?")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        return chartData
    }
    
    func getCostsByCategoryForDate(date: Date) -> [(category: CategoryModel, cost: Double)] {
        let category1 = CategoryModel()
        let category2 = CategoryModel()
        let category3 = CategoryModel()
        
        category1.name = "cat1"
        category2.name = "cat2"
        category3.name = "cat3"
        
        return [
            (category: category1, cost: 15000),
            (category: category2, cost: 15000),
            (category: category3, cost: 15000)
        ]
    }
    
    func getSumCostForDate(date: Date) -> Double {
        return [1000,2000,3000,4000,5000][Int(arc4random()%5)]
    }
    
    func getSumCostForMonth(month: Date) -> Double {
        return [100000,200000,150000,175000,90000][Int(arc4random()%5)]
    }
    
}
