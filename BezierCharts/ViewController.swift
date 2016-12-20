//
//  ViewController.swift
//  BezierCharts
//
//  Created by janderton on 11/30/16.
//  Copyright © 2016 Nav Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var multiColorDonutView: MultiColorDonutView!
    @IBOutlet weak var singleColorDonutView: SingleColorDonutView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        singleColorDonutView.animated   = true
        singleColorDonutView.percent    = 0.7
        
        
        multiColorDonutView.strokeWidth = 30
        
        let slices:[DonutSlice] = [
            DonutSlice(percent: 0.5, color: .red),
            DonutSlice(percent: 0.25, color: .orange),
            DonutSlice(percent: 0.125, color: .green),
            DonutSlice(percent: 0.125, color: .blue),
        ]
        
        do {
            try multiColorDonutView.setSlices(slices)
        } catch {
            print("Slices exceed 100%")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

}

