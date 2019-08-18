//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, CustomCollectionViewDelegate {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var monthsCollectionView: CustomCollectionView!
    @IBOutlet weak var yearsCollectionView: CustomCollectionView!
    @IBOutlet weak var rightView: UIView!
    
    private let monthsValues: [String] = [
        "Whole Year", "January", "February", "March", "April", "Mai", "June", "July",
        "August", "September", "October", "November", "December"
    ]
    
    private var activeYear: Int = 0
    private var activeMonth: Int = 0
    private var activeTask: Bool = true
    
    var progressVM = ProgressViewModel()
    
    var data: [GoalData] = []
    var months: [String : [[GoalData]]] = [:]
    
    var monthsGraph: AAChartView = AAChartView()
    var monthsModel: AAChartModel = AAChartModel()
    var yearsGraph: AAChartView = AAChartView()
    var yearsModel: AAChartModel = AAChartModel()
    
    var progressGraph: AAChartView = AAChartView()
    
    private var attributes: [NSAttributedString.Key : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthsCollectionView.customDelegate = self
        yearsCollectionView.customDelegate = self
        
        data = progressVM.loadData()
        
        setupUI()
        prepareData()
        setupSideViews()
        
        setYearsCollectionView()
        setMonthsCollectionView()
        
        setUpGraphs2(firstTime: true)
    }
    
    private func setupUI() {
        
        segmentedControl.tintColor = UIColor.Main.deepPeacoockBlue
        let font = UIFont(name: "AvenirNextCondensed-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        attributes = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.kern : -0.2,
            NSAttributedString.Key.foregroundColor : UIColor.Main.rosin
        ]
        monthsCollectionView.backgroundColor = UIColor.Main.deepPeacoockBlue
        yearsCollectionView.backgroundColor = UIColor.Main.deepPeacoockBlue
    }
    
    private func setText(_ text: String) {
        
        print(view.frame)
        titleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    private func setYearsCollectionView() {
        
        var distinctYears: [String] = []
        months.forEach { distinctYears.append($0.key) }
        
        let monthsAvilablility: [Bool] = Array(repeating: true, count: distinctYears.count)
        
        distinctYears.sort()
        activeYear = Int(distinctYears.first ?? "2019")!
        
        yearsCollectionView.data = distinctYears
        yearsCollectionView.isDataAvailable = monthsAvilablility
        yearsCollectionView.type = .yearsCell
        yearsCollectionView.reloadData()
    }
    
    private func setMonthsCollectionView() {
        
        var monthsAvilablility: [Bool] = [true]
        if let currentMonths = months[String(activeYear)] {
            currentMonths.forEach {
                monthsAvilablility.append(!$0.isEmpty)
            }
        }
        if !monthsAvilablility[activeMonth] { activeMonth = 0 }
        monthsCollectionView.data = monthsValues
        monthsCollectionView.isDataAvailable = monthsAvilablility
        monthsCollectionView.type = .monthsCell
        monthsCollectionView.reloadData()
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
    
    func prepareData() {
        var monthArray: [GoalData] = []
        var monthsArray: [[GoalData]] = Array(repeating: [], count: 12)
        var yearArray: [GoalData] = []
        yearArray.removeAll()
        monthArray.removeAll()
        
        var workingYear = ""
        var workingMonth = ""
        
        var i = 0
        let count = data.count
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        data.forEach { goalData in
            
            let array = formatter.string(from: goalData.date!).split(separator: "-").map { String($0) }
            
            if workingYear != String(array[0]) {
                if workingYear != "" {
                    
                    if let month = Int(workingMonth) {
                        
                        monthsArray[month - 1] = monthArray
                        monthArray.removeAll()
                    }
                    months[workingYear] = monthsArray
                    monthsArray = Array(repeating: [], count: 12)
                }
                workingYear = String(array[0])
            }
            
            if workingMonth != String(array[1]) {
                if workingMonth != "" {
                    
                    if let month = Int(workingMonth) {
                        
                        monthsArray[month - 1] = monthArray
                        monthArray.removeAll()
                    }
                }
                workingMonth = String(array[1])
            }
            monthArray.append(goalData)
            
            i += 1
            if count == i {
                
                if let month = Int(workingMonth) {
                    monthsArray[month - 1] = monthArray
                }
                months[workingYear] = monthsArray
            }
        }
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "YYYY"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
    }
    
//    func showTasksGraph() {
//        graphView.subviews.last?.removeFromSuperview()
//        monthsModel = AAChartModel()
//        setUpGraphs()
//    }
    
    
//    func showYearGraph() {
//        graphView.subviews.last?.removeFromSuperview()
//        yearsModel = AAChartModel()
//        setUpGraphs()
//    }
    
    func setUpGraphs2(firstTime: Bool = false) {
        
        if firstTime {
            progressGraph.frame = graphView.bounds
            progressGraph.scrollEnabled = false
            graphView.addSubview(progressGraph)
        }
        let graphModel = createGraphModel()
        progressGraph.aa_drawChartWithChartModel(graphModel)
    }
    
    func createGraphModel() -> AAChartModel {
        
        var data: [Int] = []
        var categories: [String] = []
        
        if activeMonth != 0 {
            data = createMonthGraphData()
            categories = Array(1 ... data.count).map { String($0) }
            while (categories.count < 31) {
                categories.append("")
            }
        } else {
            data = createYearGraphData()
            categories = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        }
        
        let model = AAChartModel()
            .chartType(activeTask ? .bar : activeMonth != 0 ? .pie : .area)
            .stacking(.none)
            .animationType(.easeInBack)
            .dataLabelEnabled(false)
            .title("")
            .inverted(activeMonth == 0 && !activeTask ? true : false)
            .colorsTheme(["#008481", "#4FA49A", "#93BBAD", "#F1E3D0", "#294D57"])
            .categories(categories)
        
        model
            .series([
                AASeriesElement()
                    .name(activeTask ? "Tasks" : "Goals")
                    .allowPointSelect(false)
                    .data(!activeTask && activeMonth != 0 ? createDict(data: data) : data)
                    .toDic()!
                ])
        
        return model
    }
    
    func createYearGraphData() -> [Int] {
        
        let year = months[String(activeYear)]!
        
        setText(String(activeYear))
        
        var array: [Int] = []
        
        if activeTask {
            year.forEach { month in
                
                var tasksCompleted = 0
                month.forEach {
                    tasksCompleted += $0.getNumberOfTaskCompletions()
                }
                array.append(tasksCompleted)
            }
        } else {
            year.forEach { month in
                
                array.append(month.filter { Int($0.goalCompletion) == 3 }.count)
            }
        }
        return array
    }
    
    func createMonthGraphData() -> [Int] {
        
        let month = months[String(activeYear)]![activeMonth - 1]
        guard let firstDate = month.first?.date else { abort() }
        
        let daysInThisMonth = firstDate.daysInMonth()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let dateString = formatter.string(from: firstDate)
        setText(dateString)
        
        var array: [Int]!
        
        if activeTask {
            
            array = Array(repeating: 0, count: daysInThisMonth)
            formatter.dateFormat = "dd"
            month.forEach {
                
                if let dayInt = Int(formatter.string(from: $0.date!)) {
                    array[dayInt - 1] = $0.getNumberOfTaskCompletions()
                }
            }
        } else {
            
            array = Array(repeating: 0, count: 5)
            month.forEach { array[Int($0.goalCompletion)] += 1 }
        }
        return array
    }
    
//    func setUpGraphs() {
//        monthsGraph.frame = graphView.bounds
//        monthsGraph.scrollEnabled = false
//        yearsGraph.frame = graphView.bounds
//        yearsGraph.scrollEnabled = false
//
//        monthsModel
//            .chartType(activeTask ? .bar : .pie)
//            .stacking(.none)
//            .animationType(.easeInBack)
//            .dataLabelEnabled(false)
//            .title("")
//            .colorsTheme(["#008481", "#a188b1", "#12rtc7", "#1f4ab1", "#aaaaaa", "#8f6cc1"])
//            .categories(activeTask ? [
//                "1", "2", "3", "4", "5", "6","7", "8", "9", "10",
//                "11", "12", "13", "14", "15", "16","17", "18", "19", "20",
//                "21", "22", "23", "24", "25", "26","27", "28", "29", "30",
//                "31"
//                ] : [])
//
//        yearsModel = AAChartModel()
//        yearsModel
//            .chartType(activeTask ? .bar : .area)
//            .inverted(activeTask ? false : true)
//            .stacking(.none)
//            .animationType(.easeInBack)
//            .dataLabelEnabled(false)
//            .title("")
//            .colorsTheme(["#008481"])
//            .categories([
//                "Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct",
//                "Nov", "Dec"
//                ])
//
//        if activeMonth != 0 {
//            feedDataToMonthsGraph(withIndex: activeMonth, first: true)
//            monthsGraph.aa_drawChartWithChartModel(monthsModel)
//        }
//        graphView.addSubview(activeMonth != 0 ? monthsGraph : yearsGraph)
//    }
    
    func feedDataToMonthsGraph(withIndex index: Int, first: Bool = false) {
        
        let section = months[String(activeYear)]![index - 1]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let dateString = formatter.string(from: (section.first?.date!)!)
        
        setText(dateString)

        let data = createMonthData(from: section)
        updateMonthGraph(data: data, first: first)
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
            ["Completed", data[1]],
            ["TwoTHirds", data[2]],
            ["OneThird", data[3]],
            ["NotCompleted", data[0]],
            ["NotYetAchieved", data[4]
            ]
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
    
    var isCalendarToggled: Bool = false

    func toggleCalendar(immediately: Bool = false) {
        isCalendarToggled = !isCalendarToggled
        
        let transform = transformForFraction(isCalendarToggled ? 1 : 0, ofWidth: 30)
        let transform2 = transformForFraction(isCalendarToggled ? -1 : 0, ofWidth: 30)
        let scale = (view.frame.width - 120) / view.frame.width
        let grapghTransform = isCalendarToggled ? .identity : CGAffineTransform(scaleX: scale, y: scale)
        
        if immediately {
            self.leftView.layer.transform = transform
            self.rightView.layer.transform = transform2
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.graphView.transform = grapghTransform
                self.leftView.layer.transform = transform
                self.rightView.layer.transform = transform2
            }, completion: nil)
        }
    }
    
    func setupSideViews() {
        leftView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        rightView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)

        toggleCalendar(immediately: true)
    }
    
    private func transformForFraction(_ fraction: CGFloat, ofWidth width: CGFloat) -> CATransform3D {
        //1
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0
        
        //2
        let angle = -fraction * .pi/2.0
        
        //3
        let rotateTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        return rotateTransform
    }

    func cellWasSelected(withIndex index: Int, cellType: CellType) {
        
        if cellType == .yearsCell {
            activeYear = index
            setMonthsCollectionView()
        } else {
            activeMonth = index
        }
        setUpGraphs2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.title = "FocusOn Progress"
        
        view.addVerticalGradient(of: UIColor.Gradients.greenYellowishLight)
    }
    
    @IBAction func taskGoalSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            activeTask = false
            setUpGraphs2()
        default:
            activeTask = true
            setUpGraphs2()
        }
    }
}
