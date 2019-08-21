//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 04.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var monthsCollectionView: CustomCollectionView!
    @IBOutlet weak var yearsCollectionView: CustomCollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK:- Private Properties
    
    private var progressVM = ProgressViewModel()
    
    private var labelAttributes: [NSAttributedString.Key : Any] = [:]
    
    private var progressGraph: AAChartView = AAChartView()
    private var monthsGraph: AAChartView = AAChartView()
    private var monthsModel: AAChartModel = AAChartModel()
    
    private var isCalendarToggled: Bool = false
    
    // MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthsCollectionView.customDelegate = self
        yearsCollectionView.customDelegate = self
        
        progressVM.initialize()
        
        setupUI()
        
        refreshGraph(firstTime: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.navigationItem.title = "FocusOn Progress"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        toggleNavButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        toggleNavButton()
    }
    
    // MARK:- PRIVATE
    // MARK:- Graph Methods
    
    private func refreshGraph(firstTime: Bool = false) {
        
        setLabelText(to: progressVM.getLabelText())
        
        if firstTime {
            progressGraph.frame = graphView.bounds
            progressGraph.scrollEnabled = false
            graphView.addSubview(progressGraph)
        }
        let graphModel = progressVM.createGraphModel()
        progressGraph.aa_drawChartWithChartModel(graphModel)
    }
    
    private func setYearsCollectionView() {
        
        yearsCollectionView.config(type: .yearsCell)
        let (distinctYears, monthsAvilablility) = progressVM.getYearsAndAvailability()
        yearsCollectionView.insertData(data: distinctYears, isDataAvailable: monthsAvilablility)
    }
    
    private func setMonthsCollectionView() {
        
        let (monthsNames, monthsAvailability) = progressVM.getMonthsNamesAndAvailability()
        monthsCollectionView.insertData(data: monthsNames, isDataAvailable: monthsAvailability)
    }
    
    // MARK:- Custom Methods
    
    private func setupUI() {
        
        segmentedControl.tintColor = UIColor.Main.deepPeacoockBlue
        let font = UIFont(name: "AvenirNextCondensed-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        
        labelAttributes = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.kern : -0.2,
            NSAttributedString.Key.foregroundColor : UIColor.Main.rosin
        ]
        monthsCollectionView.backgroundColor = UIColor.Main.deepPeacoockBlue
        yearsCollectionView.backgroundColor = UIColor.Main.deepPeacoockBlue
        
        view.addVerticalGradient(of: UIColor.Gradients.greenYellowishLight)
        
        leftView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        rightView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        
        toggleCalendar(immediately: true)
        
        monthsCollectionView.config(type: .monthsCell)
        setMonthsCollectionView()
        setYearsCollectionView()
    }
    
    private func setLabelText(to text: String) {
        
        titleLabel.attributedText = NSAttributedString(string: text, attributes: labelAttributes)
    }
    
    private func toggleNavButton() {
        
        if tabBarController?.navigationItem.rightBarButtonItem == nil {
            let rightButton = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(showCalendar))
            rightButton.tintColor = UIColor.Main.berkshireLace
            tabBarController?.navigationItem.rightBarButtonItem = rightButton
        } else {
            tabBarController?.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func toggleCalendar(immediately: Bool = false) {
        
        isCalendarToggled = !isCalendarToggled
        
        let transformAngle: CGFloat = isCalendarToggled ? 90 : 0
        let transformAngle2: CGFloat = isCalendarToggled ? -90 : 0
        
        let transform = CATransform3D.transform(angleInDeggres: transformAngle, yAxis: true)
        let transform2 = CATransform3D.transform(angleInDeggres: transformAngle2, yAxis: true)
        
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
    
    // MARK:- Objc Methods
    
    @objc func showCalendar() {
        
        toggleCalendar()
    }
    
    // MARK:- Action Methods
    
    @IBAction func taskGoalSegmentedControlTapped(_ sender: UISegmentedControl) {
        
        progressVM.isTaskActive = sender.selectedSegmentIndex == 0
        refreshGraph()
    }
}

// MARK:- CustomCollectionViewDelegate Methods

extension ProgressViewController: CustomCollectionViewDelegate {
    
    func cellWasSelected(withIndex index: Int, cellType: CellType) {
        
        if cellType == .yearsCell {
            progressVM.activeYear = index
            setMonthsCollectionView()
        } else {
            progressVM.activeMonth = index
        }
        refreshGraph()
    }
}
