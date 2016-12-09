//
//  File.swift
//  PFM
//
//  Created by Bence Pattogato on 03/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import Charts
import RealmSwift
import SwiftDate

protocol ChartsDataProviderProtocol {
    func getMonthPieChartData(toMonth: Date) -> PieChartData
    func getLastDaysBarChartData(days: [Date]) -> BarChartData
    func getLastMonthsBarChartData(months: [Date]) -> BarChartData
}

final class DummyChartsDataProvider: ChartsDataProviderProtocol {
    
    let transactionDataProvider: TransactionDataProviderProtocol
    
    init(transactionDataProvider: TransactionDataProviderProtocol) {
        self.transactionDataProvider = transactionDataProvider
    }
    
    func getMonthPieChartData(toMonth: Date) -> PieChartData {
        var dataEntries: [PieChartDataEntry] = []
      
        for (category, cost) in getCostsByCategoryForDate(date: toMonth) {
            let dataEntry = PieChartDataEntry(value: cost, label: category.name)
            dataEntries.append(dataEntry)
        }
        
        let colors = [
            UIColor(netHex: 0xFDE3A7),
            UIColor(netHex: 0xF5D76E),
            UIColor(netHex: 0xF5AB35),
            UIColor(netHex: 0xF39C12),
            UIColor(netHex: 0xE87E04)
        ]
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = colors
        chartDataSet.formLineWidth = 8
        chartDataSet.valueFont = NSUIFont.montserratLight(12)
        
        chartDataSet.entryLabelFont = NSUIFont.montserratLight(12)
        chartDataSet.sliceSpace = 1
        chartDataSet.selectionShift = 2
        
        return chartData
    }
    
    func getLastDaysBarChartData(days: [Date]) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, day) in days.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: getSumCostForDate(date: day))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Ez a felirat hova megy?")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.highlightColor = UIColor(netHex: 0xB4831F)
        chartDataSet.colors = [UIColor(netHex: 0xFDE3A7),
                               UIColor(netHex: 0xF5D76E),
                               UIColor(netHex: 0xF5AB35),
                               UIColor(netHex: 0xF39C12),
                               UIColor(netHex: 0xE87E04)]
        chartDataSet.valueFont = NSUIFont.montserratLight(12)
        chartDataSet.formLineWidth = 0
        
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
        
        chartDataSet.highlightColor = UIColor(netHex: 0xB4831F)
        chartDataSet.colors = [UIColor(netHex: 0xFDE3A7),
                               UIColor(netHex: 0xF5D76E),
                               UIColor(netHex: 0xF5AB35),
                               UIColor(netHex: 0xF39C12),
                               UIColor(netHex: 0xE87E04)]
        chartDataSet.valueFont = NSUIFont.montserratLight(12)
        chartDataSet.formLineWidth = 0
        
        return chartData
    }
    
    func getCostsByCategoryForDate(date: Date) -> [(category: CategoryModel, cost: Double)] {
//        let category1 = CategoryModel()
//        let category2 = CategoryModel()
//        let category3 = CategoryModel()
//        
//        category1.name = "Food"
//        category2.name = "Health"
//        category3.name = "Car"
//        
//        return [
//            (category: category1, cost: 23500),
//            (category: category2, cost: 11000),
//            (category: category3, cost: 95000)
//        ]
        
        let dateStart = date.startOfDay
        let dateEnd = date.endOfDay
        let transactions = self.transactionDataProvider.getAllTransactions(nil).filter("date BETWEEN %@", [dateStart, dateEnd])
        
        var retVal = [(category: CategoryModel, cost: Double)]()
        var dict = [CategoryModel : Double]()
        var nonCategorizedAmount: Double = 0
        
        transactions.forEach { (transaction) in
            if let category = transaction.category {
                let lastAmount = dict[category] ?? 0
                dict.updateValue(lastAmount + transaction.amount, forKey: category)
            } else {
                nonCategorizedAmount.add(transaction.amount)
            }
        }
        
        for category in dict.keys {
            retVal.append((category: category, cost: dict[category] ?? 0))
        }
        
        let noCategoryModel = CategoryModel()
        noCategoryModel.name = "Not categorized"
        retVal.append((category: noCategoryModel, cost: nonCategorizedAmount))
        
        return retVal
    }
    
    
    func getSumCostForDate(date: Date) -> Double {
//        return [1000,2000,3000,4000,5000][Int(arc4random()%5)]
        let dateStart = date.startOfDay
        let dateEnd = date.endOfDay
        let transactions = self.transactionDataProvider.getAllTransactions(nil).filter("date BETWEEN %@", [dateStart, dateEnd])
        
        var sum: Double = 0
        transactions.forEach { (transaction) in
            sum += transaction.amount
        }
        
        return sum
    }
    
    func getSumCostForMonth(month: Date) -> Double {
        let dateStart = month.startOf(component: .month)
        let dateEnd = month.endOf(component: .month)
        let transactions = self.transactionDataProvider.getAllTransactions(nil).filter("date BETWEEN %@", [dateStart, dateEnd])
        
        var sum: Double = 0
        transactions.forEach { (transaction) in
            sum += transaction.amount
        }
        
        return sum
    }
    
}
