//
//  ChartsViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 05/04/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController, PresentableView {
    
    private struct Colors {
        static let primaryChartColor = UIColor.red
        static let chartBGColor = UIColor.clear
        static let secoundaryChartColor = UIColor.green
        static let primaryLegendColor = UIColor.blue
        static let secoundaryLegendColor = UIColor.purple
    }
    
    var presenter: ChartsViewPresenterProtocol?
    
    @IBOutlet weak var currentMonthPieChartView: PieChartView!
    @IBOutlet weak var lastFewDaysBarChartView: BarChartView!
    @IBOutlet weak var lastFewMonthBarChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToInputButtonTouched(_ sender: AnyObject) {
        self.presenter?.navigateToInputScreen()
    }

}

extension ChartsViewController: ChartsViewProtocol {
    
    func setCharts() {
        print("charts set")
    }
    
}
