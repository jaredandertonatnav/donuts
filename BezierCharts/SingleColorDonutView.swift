//
//  SingleColorDonutView.swift
//  BezierCharts
//
//  Created by janderton on 12/13/16.
//  Copyright © 2016 Nav Technologies. All rights reserved.
//

import UIKit
class SingleColorDonutView: DonutView {
    
    var percent: CGFloat    = 0 {
        didSet {
            do {
                try setSlices( [DonutSlice(percent: percent)] )
            } catch {
                print("Slices exceed 100%")
            }
        }
    }
    
    override func colorForSlice(_ slice: DonutSlice) -> UIColor {
        return DonutSlice.colorForPercent(percent)
    }
    
    override func prepareForInterfaceBuilder() {
        self.percent = 0.65    
    }
}


