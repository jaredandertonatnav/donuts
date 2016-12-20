//
//  Donut.swift
//  BezierCharts
//
//  Created by janderton on 11/30/16.
//  Copyright © 2016 Nav Technologies. All rights reserved.
//

import UIKit
@IBDesignable
class DonutView: UIView {
    
    var strokeWidth: CGFloat = 10
    private var slices = [DonutSlice]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    lazy var shapeLayers            = [CAShapeLayer]()
    lazy var separatorShapeLayers   = [CAShapeLayer]()
    lazy var baseShapeLayer         = CAShapeLayer()
    lazy var tempBaseShapeLayer     = CAShapeLayer()
    lazy var sliceEndAngles         = [CGFloat]()
    
    var animated            = false
    var animationDuration   = 500 // milliseconds
    
    var negativeSpaceColor:UIColor  = .lightGray
    var donutHoleColor:UIColor      = .clear
    var separatorColor:UIColor      = .white
    
    
    var showSeparators:Bool {
        return slices.count > 1
    }
    var separatorPercentage: CGFloat = (0.5 / 100) // 1/2 of 1% (of the pie)
    
    var arcCenter: CGPoint = .zero
    var radius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        prepareForDraw(rect)
        removeExistingShapeLayers()
        
        if animated {
            drawNegativeSpaceForAnimationEffect()
        }
        
        
        let startOffset = CGFloat(M_PI * 1.5) // start at the top point of the circle, not the right
        var startAngle  = startOffset
        let endAngle    = startAngle + CGFloat(M_PI * 2)
        
        
        
        for slice in slices {
            let radians = drawSlice(slice, startAngle: startAngle)
            startAngle += radians
            sliceEndAngles.append(startAngle)
        }
        
        
        
        if showSeparators {
            var sliceOffset: CGFloat = 0
            for sliceEndAngle in sliceEndAngles {
                drawSeparator(sliceEndAngle, offset: sliceOffset)
                sliceOffset += sliceEndAngle
            }
        }
        
        if startAngle < endAngle {
            drawNegativeSpaceForRemainerOfShape(startAngle, endAngle)
        }
    }
    
    func setSlices(_ slices: [DonutSlice]) throws {
        var totalPercent:CGFloat = 0
        for slice in slices {
            totalPercent += slice.percent
            if totalPercent > 1 {
                throw DonutSliceError.slicesExceed100Percent
            }
        }
        self.slices = slices        
    }

    
    func prepareForDraw(_ rect: CGRect) {
        arcCenter   = CGPoint(x: rect.width / 2, y:  rect.height / 2)
        radius      = (rect.width - strokeWidth) / 2
    }
    
    func colorForSlice(_ slice: DonutSlice) -> UIColor {
        return slice.color!
    }
    
    func drawSlice(_ slice: DonutSlice, startAngle: CGFloat) -> CGFloat {
        let percent = slice.percent
        let color   = colorForSlice(slice)
        
        let radians             = getRadians(fromPercent: percent)
        let endAngle            = startAngle + radians
        let arcPath             = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        
        let shapeLayer          = CAShapeLayer()
        shapeLayer.path         = arcPath.cgPath
        shapeLayer.fillColor    = donutHoleColor.cgColor
        shapeLayer.strokeColor  = color.cgColor
        shapeLayer.lineWidth    = strokeWidth
        
        if animated {
            let pathAnimation       = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration  = Double(Float(animationDuration) / Float(1000))
            pathAnimation.fromValue = 0
            pathAnimation.toValue   = 1
            shapeLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        }
        
        layer.addSublayer(shapeLayer)
        shapeLayers.append(shapeLayer)
        
        return radians
    }
    
    
    
    func drawSeparator(_ sliceEndAngle: CGFloat, offset: CGFloat) {
        let radiansForSeparator = getRadians(fromPercent: separatorPercentage)
        
        let shapeLayer          = CAShapeLayer()
        
        let startAngle          = sliceEndAngle - (radiansForSeparator / 2)
        let endAngle            = sliceEndAngle + (radiansForSeparator / 2)
        
        let arcPath             = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        shapeLayer.path         = arcPath.cgPath
        shapeLayer.fillColor    = donutHoleColor.cgColor
        shapeLayer.strokeColor  = separatorColor.cgColor
        shapeLayer.lineWidth    = strokeWidth
        
        layer.addSublayer(shapeLayer)
        separatorShapeLayers.append(shapeLayer)
    }
    
    func drawNegativeSpaceForRemainerOfShape(_ startAngle: CGFloat, _ endAngle: CGFloat) {
        let baseCirclePath2         = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        baseShapeLayer.path         = baseCirclePath2.cgPath
        baseShapeLayer.fillColor    = donutHoleColor.cgColor
        baseShapeLayer.strokeColor  = negativeSpaceColor.cgColor
        baseShapeLayer.lineWidth    = strokeWidth
        layer.addSublayer(baseShapeLayer)
    }
    
    
    func drawNegativeSpaceForAnimationEffect() {
        // draw the background color, that the color is going to be animated over
        let baseCirclePath              = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        tempBaseShapeLayer.path         = baseCirclePath.cgPath
        tempBaseShapeLayer.fillColor    = donutHoleColor.cgColor
        tempBaseShapeLayer.strokeColor  = negativeSpaceColor.cgColor
        tempBaseShapeLayer.lineWidth    = strokeWidth
        
        layer.addSublayer(tempBaseShapeLayer)
        
        // after the animation completes, we want to remove this layer, because while
        // its still present, the anti-aliasing creates a faint outline
        let deadlineTime = DispatchTime.now() + .milliseconds(animationDuration)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tempBaseShapeLayer.removeFromSuperlayer()
        }
    }
    
    
    func getRadians(fromPercent percent: CGFloat) -> CGFloat {
        let arcDegrees:CGFloat  = 360 * percent
        return arcDegrees * CGFloat(M_PI/180)
        
    }
    
    
    
    func removeExistingShapeLayers() {
        for shapeLayer in shapeLayers {
            shapeLayer.removeFromSuperlayer()
        }
        
        for shapeLayer in separatorShapeLayers {
            shapeLayer.removeFromSuperlayer()
        }
        
        baseShapeLayer.removeFromSuperlayer()
        tempBaseShapeLayer.removeFromSuperlayer()
        
        sliceEndAngles.removeAll()
        shapeLayers.removeAll()
        separatorShapeLayers.removeAll()
    }
    
    
}



enum DonutSliceError: Error {
    case slicesExceed100Percent
}


