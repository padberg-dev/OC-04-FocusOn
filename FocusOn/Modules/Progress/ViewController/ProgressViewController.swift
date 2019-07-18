//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, CustomCollectionViewDelegate {
    
    @IBOutlet weak var customCollectionView: CustomCollectionView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftCustomCollectionView: CustomCollectionView!
    @IBOutlet weak var rightView: UIView!
    
    var activeCVIndex = 0 {
        didSet {
            if activeMonth {
                feedDataToMonthsGraph(withIndex: activeCVIndex, first: false)
            } else {
                feedDataToYearsGraph(withIndex: activeCVIndex, first: false)
            }
            customCollectionView.highlightCell(withIndex: activeCVIndex)
            leftCustomCollectionView.highlightCell(withIndex: activeCVIndex)
        }
    }
    var activeTask = true
    var activeMonth = true

    var progressVM = ProgressViewModel()
    
    var data: [GoalData] = []
    var months: [[GoalData]] = []
    var years: [[GoalData]] = []
    
    var monthsGraph: AAChartView = AAChartView()
    var monthsModel: AAChartModel = AAChartModel()
    var yearsGraph: AAChartView = AAChartView()
    var yearsModel: AAChartModel = AAChartModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customCollectionView.customDelegate = self
        leftCustomCollectionView.customDelegate = self
        
        print("START")
        data = progressVM.loadData()
        print("DONE")
        print(data.count)
        
        prepareData()
        
        setCollectionViewData()
        setCollectionViewData2()
        
        setUpGraphs()
        
        setupSideViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(showCalendar))
        rightButton.tintColor = UIColor.Main.berkshireLace
        
        self.tabBarController?.navigationItem.rightBarButtonItem  = rightButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func showCalendar() {
        toggleCalendar()
    }
    
    func setCollectionViewData() {
        if activeMonth {
            var collectionMonths: [String] = []
            months.forEach { (month) in
                let date = month.first?.date
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY MMM"
                
                collectionMonths.append(formatter.string(from: date!))
            }
            
            customCollectionView.data = collectionMonths
        } else {
            var collectionYears: [String] = []
            years.forEach { (year) in
                let date = year.first?.date
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY"
                
                collectionYears.append(formatter.string(from: date!))
            }
            
            customCollectionView.data = collectionYears
        }
        
        customCollectionView.reloadData()
    }
    
    
    func setCollectionViewData2() {
        var collectionMonths: [String] = []
        months.forEach { (month) in
            let date = month.first?.date
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY MMM"
            
            collectionMonths.append(formatter.string(from: date!))
        }
        
        leftCustomCollectionView.data = collectionMonths
    
//        var collectionYears: [String] = []
//        years.forEach { (year) in
//            let date = year.first?.date
//            let formatter = DateFormatter()
//            formatter.dateFormat = "YYYY"
//
//            collectionYears.append(formatter.string(from: date!))
//        }
//
//        customCollectionView.data = collectionYears
        
        customCollectionView.reloadData()
    }
    
    func prepareData() {
        var yearArray: [GoalData] = []
        yearArray.removeAll()
        var monthArray: [GoalData] = []
        monthArray.removeAll()
        
        var workingYear = ""
        var workingMonth = ""
        
        var i = 0
        let count = data.count
        data.forEach { goalData in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM"
            let array = formatter.string(from: goalData.date!).split(separator: "-")
            
            if workingYear != String(array[0]) {
                workingYear = String(array[0])
                if !yearArray.isEmpty {
                    years.append(yearArray)
                    yearArray.removeAll()
                }
            }
            
            if workingMonth != String(array[1]) {
                workingMonth = String(array[1])
                if !monthArray.isEmpty {
                    months.append(monthArray)
                    monthArray.removeAll()
                }
            }
            
            yearArray.append(goalData)
            monthArray.append(goalData)
            i += 1
            if count == i {
                years.append(yearArray)
                months.append(monthArray)
            }
        }
        print(years.count)
        print(months.count)
    }
    
    func showTasksGraph() {
        graphView.subviews.last?.removeFromSuperview()
        monthsModel = AAChartModel()
        setUpGraphs()
    }
    
    
    func showYearGraph() {
        graphView.subviews.last?.removeFromSuperview()
        yearsModel = AAChartModel()
        setUpGraphs()
    }
    
    func setUpGraphs() {        
        monthsGraph.frame = graphView.bounds
        monthsGraph.scrollEnabled = false
        yearsGraph.frame = graphView.bounds
        yearsGraph.scrollEnabled = false
        
        monthsModel
            .chartType(activeTask ? .bar : .pie)
            .stacking(.none)
            .animationType(.easeInBack)
            .dataLabelEnabled(false)
            .title("")
            .colorsTheme(["#fe117c", "#a188b1", "#12rtc7", "#1f4ab1", "#aaaaaa", "#8f6cc1"])
            .categories(activeTask ? [
                "1", "2", "3", "4", "5", "6","7", "8", "9", "10",
                "11", "12", "13", "14", "15", "16","17", "18", "19", "20",
                "21", "22", "23", "24", "25", "26","27", "28", "29", "30",
                "31"
                ] : [])
        
        yearsModel = AAChartModel()
        yearsModel
            .chartType(activeTask ? .bar : .area)
            .inverted(activeTask ? false : true)
            .stacking(.none)
            .animationType(.easeInBack)
            .dataLabelEnabled(false)
            .title("")
            .colorsTheme(["#fe117c"])
            .categories([
                "Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct",
                "Nov", "Dec"
                ])
        
        if activeMonth {
            feedDataToMonthsGraph(withIndex: activeCVIndex, first: true)
            monthsGraph.aa_drawChartWithChartModel(monthsModel)
        } else {
            feedDataToYearsGraph(withIndex: activeCVIndex, first: true)
            yearsGraph.aa_drawChartWithChartModel(yearsModel)
        }
        graphView.addSubview(activeMonth ? monthsGraph : yearsGraph)
    }
    
    func feedDataToMonthsGraph(withIndex index: Int, first: Bool = false) {
        let section = months[index]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let dateString = formatter.string(from: (section.first?.date!)!)
        
        titleLabel.text = dateString
        
        let data = createMonthData(from: section)
        updateMonthGraph(data: data, first: first)
    }
    
    func feedDataToYearsGraph(withIndex index: Int, first: Bool = false) {
        let section = years[index]
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let dateString = formatter.string(from: (section.first?.date!)!)
        
        titleLabel.text = dateString
        
        let data = createYearData(from: section)
        updateYearGraph(data: data, first: first)
    }
    
    func createYearData(from years: [GoalData]) -> [Int] {
        var array: [Int] = Array(repeating: 0, count: 12)
        var monthSum: Int = 0

        var workingMonth = ""
        
        years.forEach { (day) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM"
            let month = String(formatter.string(from: day.date!))

            if workingMonth != month {
                if monthSum != 0 {
                    array[Int(workingMonth)! - 1] = monthSum
                    monthSum = 0
                }
                workingMonth = month
            }
            monthSum += activeTask ? day.getNumberOfTaskCompletions() : Int(day.goalCompletion) == 3 ? 1 : 0
        }
        return array
    }
    
    func createMonthData(from months: [GoalData]) -> [Int] {
        var array: [Int] = []
        var activeIndex = 0
        
        if !activeTask {
            array.append(0)
            array.append(0)
            array.append(0)
            array.append(0)
            array.append(0)
            months.forEach { (day) in
                array[Int(day.goalCompletion)] += 1
            }
        } else {
            for i in 0 ..< 31 {
                let goalData = months[activeIndex]
                let formatter = DateFormatter()
                formatter.dateFormat = "dd"
                let string = formatter.string(from: goalData.date!)
                
                if 31 - i == Int(string) {
                    array.append(goalData.getNumberOfTaskCompletions())
                    activeIndex += 1
                } else {
                    array.append(0)
                }
            }
        }
        return array.reversed()
    }
    
    func createDict(data: [Int]) -> [[Any]] {
        let dictOfAny = [
            ["NotCompleted", data[4]],
            ["OneThird", data[3]],
            ["TwoTHirds", data[2]],
            ["Completed", data[1]],
            ["NotYetAchieved", data[0]]
        ]
        return dictOfAny
    }
    
    func updateMonthGraph(data: [Int], first: Bool = false) {
        if first {
            
            monthsModel
                .series([
                AASeriesElement()
                    .name(activeTask ? "Tasks" : "Goals")
                    .allowPointSelect(false)
                    .data(activeTask ? data : createDict(data: data))
                    .toDic()!
                ])
            print("FIRST")
        } else {
            self.monthsGraph.aa_onlyRefreshTheChartDataWithChartModelSeries([
                AASeriesElement()
                    .name(activeTask ? "Tasks" : "Goals")
                    .allowPointSelect(false)
                    .data(activeTask ? data : createDict(data: data))
                    .toDic()!
                ])
        }
    }
    
    func updateYearGraph(data: [Int], first: Bool = false) {
        if first {
            yearsModel
                .series([
                    AASeriesElement()
                        .name(activeTask ? "Tasks" : "Goals")
                        .allowPointSelect(false)
                        .data(data)
                        .toDic()!
                    ])
        } else {
            self.yearsGraph.aa_onlyRefreshTheChartDataWithChartModelSeries([
                AASeriesElement()
                    .name(activeTask ? "Tasks" : "Goals")
                    .allowPointSelect(false)
                    .data(data)
                    .toDic()!
                ])
        }
    }
    
    var isCalendarToggled: Bool = false
    
    func toggleCalendar(immediately: Bool = false) {
        isCalendarToggled = !isCalendarToggled
        
        let transform = transformForFraction(isCalendarToggled ? 1 : 0, ofWidth: 30)
        let transform2 = transformForFraction(isCalendarToggled ? -1 : 0, ofWidth: 30)
        let grapghTransform = isCalendarToggled ? .identity : CGAffineTransform(scaleX: 0.67, y: 0.67)
        
        if immediately {
            self.leftView.layer.transform = transform
            self.rightView.layer.transform = transform2
        } else {
        UIView.animate(withDuration: 0.6, animations: {
            self.graphView.transform = grapghTransform
            self.leftView.layer.transform = transform
            self.rightView.layer.transform = transform2
        }, completion: { [weak self] _ in
            
        })
        }
    }
    
    func setupSideViews() {
        leftView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        rightView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        
        toggleCalendar(immediately: true)
    }
    
    private func transformForFraction(_ fraction: CGFloat, ofWidth width: CGFloat)
        -> CATransform3D {
            //1
            var identity = CATransform3DIdentity
            identity.m34 = -1.0 / 1000.0
            
            //2
            let angle = -fraction * .pi/2.0
            
            //3
            let rotateTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
            return rotateTransform
    }
    
    func cellWasSelected(withIndex index: Int) {
        activeCVIndex = index
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Progress"
    }
    
    
    @IBAction func taskGoalSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            activeTask = false
            showTasksGraph()
        default:
            activeTask = true
            showTasksGraph()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        activeCVIndex = 0
        switch sender.selectedSegmentIndex {
        case 1:
            activeMonth = false
            showYearGraph()
        default:
            activeMonth = true
            showYearGraph()
        }
        setCollectionViewData()
    }
}
