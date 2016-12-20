//
//  DonutSlice.swift
//  BezierCharts
//
//  Created by janderton on 12/13/16.
//  Copyright © 2016 Nav Technologies. All rights reserved.
//

import UIKit
struct DonutSlice {
    var color: UIColor? 
    var percent: CGFloat    = 0
    
    init (percent: CGFloat) {
        self.percent    = percent
        self.color      = DonutSlice.colorForPercent(percent)
    }
    
    init (percent: CGFloat, color: UIColor) {
        self.percent    = percent
        self.color      = color
    }
    
    static func colorForPercent(_ percent: CGFloat) -> UIColor {
        if percent < 0.5 {
            return .red
        } else if percent < 0.75 {
            return .orange
        } else {
            return .green
        }
    }
}
