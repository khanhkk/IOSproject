 //
//  ViewController.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/13/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import UIKit
import os.log

enum MyTheme {
    case light
    case dark
}


struct Colors {
    static var darkGray = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.black
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    //define template theme dark
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    //define template theme light
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}


protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}




var theme = MyTheme.dark

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource , MonthViewDelegate, UITableViewDataSource{
    
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    //var delegate: MonthViewDelegate?
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var actions = [Action]()
    var allActions = [Action]()
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var days: WeekdaysView!
    
    @IBOutlet weak var lblNameMonth: UILabel!
    
    @IBOutlet weak var CalendarData: UICollectionView!
    
    
    @IBAction func btnNextMonth(_ sender: UIButton) {
        //os_log("1", log: .default, type: .debug)
        currentMonthIndex += 1
        if currentMonthIndex-1 > 11 {
            currentMonthIndex = 1
            currentYear += 1
        }
        lblNameMonth.text="\(monthsArr[currentMonthIndex - 1]) \(currentYear)"
        didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)

    }
    
    
    @IBAction func btnPreviousMonth(_ sender: UIButton) {
        //os_log("0", log: .default, type: .debug)
        currentMonthIndex -= 1
        if currentMonthIndex-1 < 0 {
            currentMonthIndex = 12
            currentYear -= 1
        }
        lblNameMonth.text="\(monthsArr[currentMonthIndex - 1]) \(currentYear)"
        didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    
//    @IBAction func btnChangeTheme(_ sender: UIBarButtonItem) {
//        if theme == .dark {
//            sender.title = "Dark"
//            theme = .light
//            Style.themeLight()
//        } else {
//            sender.title = "Light"
//            theme = .dark
//            Style.themeDark()
//        }
//        self.view.backgroundColor=Style.bgColor
//        //CalenderView.changeTheme()
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        lblNameMonth.text = "\(monthsArr[currentMonthIndex - 1]) \(currentYear)"
        
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        CalendarData.showsHorizontalScrollIndicator = false
        CalendarData.translatesAutoresizingMaskIntoConstraints=false
        CalendarData.allowsMultipleSelection=false
        CalendarData.delegate = self
        CalendarData.dataSource = self
        CalendarData.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
        
        loadData()
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter2.date(from: "\(presentYear)/\(presentMonthIndex)/\(todaysDate)")
        filter(date: currentDate!, acs: allActions)
        table.reloadData()
        table.dataSource = self
    }
    
    //TABLEVIEW FOR ACTION
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //os_log("0", log: .default, type: .debug)
        return actions.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellTable"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActionsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let action = actions[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        
        cell.lblActionName.text = action.name
        cell.lblActionName.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        cell.lblTime.text = "\(dateFormatter.string(from: action.time!))"
        if action.plan?.getTitle() != nil{
            cell.lblPlan.text = action.plan?.getTitle()
        }
        else{
            cell.lblPlan.text = "<None>"
        }
        
        
        return cell
    }

    
    func loadData() {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy/MM/dd"
        
        let dateOfBirth = formatter2.date(from: "1996/10/28")
        
        let user = User(code: "us1", name: "khanh", dob : dateOfBirth, add: "quan 9", email: "vudinhkhanh2810@gmail.com", photo : nil)
        
        let formatter = DateFormatter()
        //formatter.timeStyle = .short
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2018/01/15 22:31")
        let time2 = formatter.date(from: "2017/12/17 08:00")
        let time3 = formatter.date(from: "2017/12/17 16:00")
        
        let timeSt = formatter.date(from: "2017/12/15 07:00")
        let timeFn = formatter.date(from: "2017/12/31 17:00")
        
        //let str = formatter.string(from: time2!)
        //print("fdgs")
        //os_log("", log: .default, type: .debug)
        
        let plan = Plan(code: "kh1", title: "ke hoach 1", timeStart: timeSt, timeFinish: timeFn, note: "can hoan thanh som")
        
        guard let action1 = Action(id: "ac1", name: "cong viec 1", plan : nil, implementer: user, content: "code cho xong", time: someDateTime, comment: "") else {
            fatalError("Unable to instantiate action")
        }
        
        guard let action2 = Action(id: "ac2", name: "cong viec 2", plan : plan, implementer: user, content: "code cho xong", time: time2, comment: "") else {
            fatalError("Unable to instantiate action")
        }
        
        guard let action3 = Action(id: "ac3", name: "cong viec 3", plan : plan, implementer: user, content: "fix code", time: time3, comment: "de xot loi") else {
            fatalError("Unable to instantiate action")
        }
        
        allActions += [action1,action2,action3]
    }

    
    func filter(date: Date, acs : [Action]) {
        actions.removeAll()
        
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .short
        let day1 = formatter2.string(from: date)
        
        for item in acs {
            let day2 = formatter2.string(from: item.getTime()!)
            if day2 == day1
            {
                actions.append(item)
            }
        }
        
    }
    
    //COLLECTIONVIEW FOR CALENDAR
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        CalendarData.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy/MM/dd"
            let currentDate = formatter2.date(from: "\(currentYear)/\(currentMonthIndex)/\(calcDate)")
            filter(date: currentDate!, acs: allActions)
            if actions.count != 0
            {
                cell.lblFlag.text = "\(actions.count)"
                cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
            }
            else
            {
                cell.lblFlag.text = ""
                //cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
            }
            
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            cell.lbl.textAlignment = .center
            
            if currentYear < presentYear
            {
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = UIColor.lightGray
                if (indexPath.hashValue + 6) % 7 == 0
                {
                    cell.lbl.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }
                if (indexPath.hashValue + 7) % 7 == 0
                {
                    cell.lbl.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                }            }
            else
            {
                if currentYear == presentYear
                {
                    if currentMonthIndex < presentMonthIndex
                    {
                        cell.isUserInteractionEnabled=false
                        cell.lbl.textColor = UIColor.lightGray
                        if (indexPath.hashValue + 6) % 7 == 0
                        {
                            cell.lbl.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                        }
                        if (indexPath.hashValue + 7) % 7 == 0
                        {
                            cell.lbl.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        }
                    }
                    else
                    {
                        if currentMonthIndex == presentMonthIndex
                        {
                            if calcDate < todaysDate
                            {
                                cell.isUserInteractionEnabled=false
                                cell.lbl.textColor = UIColor.lightGray
                                if (indexPath.hashValue + 6) % 7 == 0
                                {
                                    cell.lbl.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                                }
                                if (indexPath.hashValue + 7) % 7 == 0
                                {
                                    cell.lbl.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                                }
                                
                            }
                            else
                            {
                                if calcDate == todaysDate
                                {
                                    cell.isUserInteractionEnabled=true
                                    cell.backgroundColor = #colorLiteral(red: 0.545081241, green: 0.5409936265, blue: 0.9588932966, alpha: 1)
                                    cell.lbl.textColor = UIColor.white
                                    
//                                    if actions.count != 0
//                                    {
//                                        cell.lblFlag.text = "\(actions.count)"
//                                        cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
//                                    }
                                }
                                else
                                {
                                    cell.isUserInteractionEnabled=true
                                    cell.lbl.textColor = Style.activeCellLblColor
                                    if (indexPath.hashValue + 6) % 7 == 0
                                    {
                                        cell.lbl.textColor = UIColor.red
                                    }
                                    if (indexPath.hashValue + 7) % 7 == 0
                                    {
                                        cell.lbl.textColor = UIColor.blue
                                    }
                                    
//                                    if actions.count != 0
//                                    {
//                                        cell.lblFlag.text = "\(actions.count)"
//                                        cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
//                                    }

                                }
                            }
                        }
                        else
                        {
                            cell.isUserInteractionEnabled=true
                            cell.lbl.textColor = Style.activeCellLblColor
                            if (indexPath.hashValue + 6) % 7 == 0
                            {
                                cell.lbl.textColor = UIColor.red
                            }
                            if (indexPath.hashValue + 7) % 7 == 0
                            {
                                cell.lbl.textColor = UIColor.blue
                            }
//                            if actions.count != 0
//                            {
//                                cell.lblFlag.text = "\(actions.count)"
//                                cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
//
//                            }

                        }
                    }
                }
                else
                {
                    cell.isUserInteractionEnabled=true
                    cell.lbl.textColor = Style.activeCellLblColor
                    if (indexPath.hashValue + 6) % 7 == 0
                    {
                        cell.lbl.textColor = UIColor.red
                    }
                    if (indexPath.hashValue + 7) % 7 == 0
                    {
                        cell.lbl.textColor = UIColor.blue
                    }
//                    if actions.count != 0
//                    {
//                        cell.lblFlag.text = "\(actions.count)"
//                        cell.lblFlag.textColor  = #colorLiteral(red: 0.1409238473, green: 0.4249311852, blue: 0.1148019898, alpha: 1)
//                    }
                    
                }
            }
        }
        return cell

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter2.date(from: "\(currentYear)/\(currentMonthIndex)/\(calcDate)")

        
        filter(date: currentDate!, acs: allActions)
        table.reloadData()
        //os_log("1", log: .default, type: .debug)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
            cell?.backgroundColor = #colorLiteral(red: 0.545081241, green: 0.5409936265, blue: 0.9588932966, alpha: 1)
            //cell?.layer.cornerRadius=20
            //cell?.layer.masksToBounds=true
            let lbl = cell?.subviews[1] as! UILabel
            lbl.textColor=UIColor.white
            
        }
        else
        {
            if (indexPath.hashValue + 6) % 7 == 0
            {
                lbl.textColor = UIColor.red
            }
            if (indexPath.hashValue + 7) % 7 == 0
            {
                lbl.textColor = UIColor.blue
            }

        }
        //os_log("0", log: .default, type: .debug)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 1 : day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex
        
        currentYear = year
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        lblNameMonth.text = "\(monthsArr[currentMonthIndex - 1]) \(currentYear)"
        
        CalendarData.reloadData()
        
        //monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }

}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=20
        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        addSubview(lblFlag)
        lblFlag.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblFlag.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lblFlag.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lblFlag.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let lblFlag: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .right
        label.font=UIFont.systemFont(ofSize: 9)
        label.textColor = nil
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}



