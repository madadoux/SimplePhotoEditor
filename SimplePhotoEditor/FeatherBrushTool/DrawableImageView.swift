//
//  BrushFeatherVC+croppingControl.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/26/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.
//


import UIKit

public class DrawableImageView: UIImageView {

    public var isCropEnabled = true

    public var strokeColor:UIColor = UIColor.yellow
    
    public var lineWidth:CGFloat = 2.0
    
    var path = UIBezierPath()
    private var shapeLayer = CAShapeLayer()
    
    var isLogEnabled = true
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = isCropEnabled
    }
        
    
    public func reset() {
        path = UIBezierPath()
        shapeLayer = CAShapeLayer()
        layer.mask = nil
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

    }
    
    private func addNewPathToImage(){
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self)
            if isLogEnabled {
                debugPrint("touch begin to : \(touchPoint)")
            }
            path.move(to: touchPoint)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self)
            if isLogEnabled {
                print("touch moved to : \(touchPoint)")
            }
            path.addLine(to: touchPoint)
            addNewPathToImage()
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self)
            if isLogEnabled {
                print("touch ended at : \(touchPoint)")
            }
            path.addLine(to: touchPoint)
            addNewPathToImage()
            path.close()
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self)
            if isLogEnabled {
                print("touch canceled at : \(touchPoint)")
            }
            path.close()
        }
    }
}
