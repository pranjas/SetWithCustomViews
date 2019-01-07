//
//  SetCard.swift
//  SetCardGame
//
//  Created by Jasleen Arora Srivastava on 05/01/19.
//  Copyright © 2019 Jasleen Arora Srivastava. All rights reserved.
//

import UIKit

class SetCard: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    enum Shape: String, CustomStringConvertible {
        var description: String {
            switch self {
            case .Sqisuh:
                return "Squish card "
            case .Diamond:
                return "Diamond card"
            case .Oval:
                return "Oval card"
            }
        }
        case Diamond
        case Oval
        case Sqisuh
    }
    
    struct SetCardGraphicOptions {
        var rows: Int
        var cols: Int
        var shape: Shape
        var strokeColor: UIColor
        var fillColor: UIColor
    }
    
    var graphicOptions = SetCardGraphicOptions(rows:2, cols: 3, shape: .Oval, strokeColor: .red, fillColor: .orange) {
        didSet{
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        graphicOptions.strokeColor.setStroke()
        graphicOptions.fillColor.setFill()
        
        print("Calling Draw...")
        switch graphicOptions.shape {
        case .Oval:
            let drawingRects = bounds.split(widthFactor: 1.0 / CGFloat(graphicOptions.cols), heightFactor: 1.0 / CGFloat(graphicOptions.rows))
            for i in 0..<drawingRects.rows {
                for rect in drawingRects.rects[i] {
                    let path = UIBezierPath(ovalIn: rect)
                    path.fill()
                    path.stroke()
                }
            }
            
        case .Diamond:
            let path = UIBezierPath()
            path.move(to: bounds.midPoint.offset(0, -bounds.midY))
            path.addClip()
            path.addLine(to: bounds.midPoint.offset(-bounds.midX, bounds.midY))
            path.addLine(to: bounds.midPoint.offset(0, bounds.midY))
            path.addLine(to: bounds.midPoint.offset(bounds.midX, -bounds.midY))
            path.close()
            path.fill()
            path.stroke()
            
        case .Sqisuh:
            let path = UIBezierPath()
            path.move(to: bounds.midPoint.offset(-bounds.midX, 0))
            path.addQuadCurve(to: bounds.midPoint, controlPoint: bounds.midPoint.offset(-bounds.midX / 2, bounds.midY / 2))
            path.close()
        }
    }
}

extension CGRect {
    var midPoint: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    func resize(widthFactor : CGFloat, heightFactor: CGFloat) -> CGRect {
        
        var _widthFactor = widthFactor > 1.0 ? 1.0 : widthFactor
        var _heightFactor = heightFactor > 1.0 ? 1.0 : heightFactor
        
        _widthFactor = _widthFactor > 0 ? _widthFactor : 1.0
        _heightFactor = _heightFactor > 0 ? _heightFactor : 1.0
        
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.width * _widthFactor, height: self.height * _heightFactor)
    }
    
    func split(widthFactor: CGFloat, heightFactor: CGFloat) -> (rects: [[CGRect]], rows: Int, cols: Int) {
        var result = [[CGRect]]()
        
        let _widthfactor = widthFactor < 0 || widthFactor > 1.0 ? 1.0 : widthFactor
        let _heightfactor = heightFactor < 0 || heightFactor > 1.0 ? 1.0 : heightFactor
        
        let rows = Int(floor(Double( 1 / _widthfactor)))
        let cols = Int(floor(Double(1 / _heightfactor)))
        
        for i in 0..<rows {
            result.append([CGRect]())
            for j in 0..<cols {
                result[i].append(CGRect(x: self.origin.x + CGFloat(i) * self.width * _widthfactor,
                                        y: self.origin.y + CGFloat(j) * self.height * _heightfactor, width: self.width * _widthfactor, height: self.height * _heightfactor))
            }
        }
        return (result, rows, cols)
    }
}

extension CGPoint {
    func offset(_ offsetx: CGFloat, _ offsety :CGFloat) -> CGPoint {
        return CGPoint(x: self.x + offsetx, y: self.y + offsety)
    }
}
