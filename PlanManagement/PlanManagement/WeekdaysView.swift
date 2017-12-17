//
//  WeekdaysView.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/14/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//


import UIKit

@IBDesignable class WeekdaysView: UIStackView {
    
    private var daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
//        addSubview(myStackView)
//        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
//        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
//        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
            for i in 0..<daysArr.count {
            let lbl = UILabel()
            lbl.text=daysArr[i]
            lbl.textAlignment = .center
                if i == 6
                {
                    lbl.textColor = UIColor.blue
                }
                
                if i == 0
                {
                    lbl.textColor = UIColor.red
                }
//            lbl.heightAnchor.constraint(equalToConstant: 44).isActive=true
//                    
//            lbl.widthAnchor.constraint(equalToConstant: 44).isActive=true

            //lbl.textColor = Style.weekdaysLblColor
            addArrangedSubview(lbl)
        }
    }
    
//    let myStackView: UIStackView = {
//        let stackView=UIStackView()
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints=false
//        return stackView
//    }()
    
    required init(coder : NSCoder) {
        super.init(coder: coder)
         setupViews()
        //fatalError("init(coder:) has not been implemented")
    }
}
