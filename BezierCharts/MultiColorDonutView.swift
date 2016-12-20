//
//  MultiColorDonutView.swift
//  BezierCharts
//
//  Created by janderton on 12/13/16.
//  Copyright © 2016 Nav Technologies. All rights reserved.
//

import UIKit
class MultiColorDonutView: DonutView {
    
    override func prepareForInterfaceBuilder() {
        let slices:[DonutSlice] = [
            DonutSlice(percent: 0.5, color: .red),
            DonutSlice(percent: 0.25, color: .orange),
            DonutSlice(percent: 0.125, color: .green),
            DonutSlice(percent: 0.125, color: .blue),
            ]
        
        do {
            try self.setSlices(slices)
        } catch {
            print("Slices exceed 100%")
        }
    }
}
