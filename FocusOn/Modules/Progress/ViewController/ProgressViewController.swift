//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var progressVM = ProgressViewModel()
    
    override func awakeFromNib() {
        tabBarItem.image = UIImage(named: "progress")
        title = "Progress"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWeekGraph()
    }
    
    func createWeekGraph() {
        graphView.subviews.last?.removeFromSuperview()
        
        let aaChartView = AAChartView()
        aaChartView.frame = graphView.bounds
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        graphView.addSubview(aaChartView)
        
        let aaChartModel = AAChartModel()
            .chartType(.area)//Can be any of the chart types listed under `AAChartType`
            .stacking(.normal)
            .animationType(.easeInBack)
            .title("Week 27")//The chart title
            .subtitle("23.03 - 30.03")//The chart subtitle
            .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
                         "Sun", ""])
            .colorsTheme(["#fe117c","#ffc069"])
            .series([
                AASeriesElement()
                    .name("Goals")
                    .data([1, 0, 0, 0, 1, 0, 1, 0])
                    .step(true)
                    .toDic()!,
                AASeriesElement()
                    .name("Tasks")
                    .data([3, 2, 1, 2, 3, 3, 2, 0])
                    .step(true)
                    .toDic()!,
                ])
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    func createMonthGraph() {
        graphView.subviews.last?.removeFromSuperview()
        
        let aaChartView = AAChartView()
        aaChartView.frame = graphView.bounds
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        graphView.addSubview(aaChartView)
        
        let aaChartModel = AAChartModel()
            .chartType(.bar)//Can be any of the chart types listed under `AAChartType`
            .stacking(.normal)
            .animationType(.easeInBack)
            .title("April")//The chart title
//            .subtitle("23.03 - 30.03")//The chart subtitle
            .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["1", "2", "3", "4", "5", "6","7", "8", "9", "10",
                "11", "12", "13", "14", "15", "16","17", "18", "19", "20",
                "21", "22", "23", "24", "25", "26","27", "28", "29", "30",
                ""
                ])
            .colorsTheme(["#fe117c","#ffc069"])
            .series([
                AASeriesElement()
                    .name("Goals")
                    .data([
                        1, 0, 1, 1, 0, 1, 0, 0, 1, 1,
                        0, 1, 1, 1, 0, 0, 1, 0, 1, 0,
                        1, 0, 0, 1, 1, 1, 0, 1, 1, 1,
                        0
                        ])
                    .step(true)
                    .toDic()!,
                AASeriesElement()
                    .name("Tasks")
                    .data([
                        3, 1, 2, 3, 1, 3, 1, 2, 3, 3,
                        2, 3, 1, 3, 2, 1, 3, 2, 3, 1,
                        3, 1, 1, 3, 2, 3, 2, 3, 3, 2,
                        0
                        ])
                    .step(true)
                    .toDic()!,
                ])
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    func createYearGraph() {
        graphView.subviews.last?.removeFromSuperview()
        
        let aaChartView = AAChartView()
        aaChartView.frame = graphView.bounds
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        graphView.addSubview(aaChartView)
        
        let aaChartModel = AAChartModel()
            .chartType(.column)//Can be any of the chart types listed under `AAChartType`
            .stacking(.normal)
            .polar(true)
            .yAxisReversed(true)
            .animationType(.bounce)
            .title("April")//The chart title
            //            .subtitle("23.03 - 30.03")//The chart subtitle
            .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct",
                         "Nov", "Dec"
                ])
            .colorsTheme(["#fe117c","#ffc069"])
            .series([
                AASeriesElement()
                    .name("Goals")
                    .data([
                        12, 28, 21, 7, 25, 17, 0, 0, 0, 0,
                        0, 0
                        ])
                    .step(true)
                    .toDic()!,
                AASeriesElement()
                    .name("Tasks")
                    .data([
                        41, 81, 55, 31, 73, 61, 4, 0, 0, 0,
                        0, 0
                        ])
                    .step(true)
                    .toDic()!,
                ])
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Progress"
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            createMonthGraph()
        case 2:
            createYearGraph()
        default:
            // 0
            createWeekGraph()
        }
    }
}
