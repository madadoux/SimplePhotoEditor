//
//  template1.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/27/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.
//

import UIKit
protocol ImageCombinerProtocol
{
    func setImages(images:[UIImage])
    func getPhotosArray() -> [UIImage]
    @discardableResult
    func drawAndGetCombiningResult(at frame : CGRect)-> UIImage?
}

public class ImageCombiner2ImagesTemplate1 : ImageCombinerProtocol {
    func getPhotosArray() -> [UIImage] {
        return images
    }
    @discardableResult
    func drawAndGetCombiningResult(at frame: CGRect) -> UIImage? {
        return draw(frame: frame)
    }
    
    func setImages(images: [UIImage]) {
        self.images = images
    }
    
    private var images  = [UIImage]()
    
    
    @objc func draw(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 414, height: 295))-> UIImage? {
        
        let image1 = images[0]
        let image2 = images[1]
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        
        let size = targetFrame.size
        
        
        
        context.saveGState()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: size.height))
        bezierPath.addLine(to: CGPoint(x: size.width * 0.45, y: size.height))
        bezierPath.addLine(to: CGPoint(x: size.width * 0.55, y: 0))
        bezierPath.close()
        context.saveGState()
        bezierPath.addClip()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -targetFrame.size.height)
        let frame1 = CGRect(x: 0, y: 0, width: size.width * 0.55, height: size.height)
        
        context.draw(image2.cgImage!, in: frame1)
        
        context.restoreGState()
        UIColor.darkGray.setStroke()
        bezierPath.lineWidth = 4
        bezierPath.lineCapStyle = .square
        bezierPath.stroke()
        
        context.restoreGState()
        
        
        context.move(to: CGPoint(x: 0, y: 0      ))
        
        
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: size.width * 0.55, y: 0))
        bezierPath2.addLine(to: CGPoint(x: size.width * 0.45, y: size.height))
        bezierPath2.addLine(to: CGPoint(x: size.width , y: size.height))
        bezierPath2.addLine(to: CGPoint(x: size.width , y: 0))
        context.saveGState()
        
        bezierPath2.addClip()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -targetFrame.size.height)
        
        let frame2 = CGRect(x: size.width/2, y: 0, width: size.width/2, height: size.height)
        context.draw(image1.cgImage!, in: frame2)
        context.restoreGState()
        UIColor.gray.setStroke()
        bezierPath2.lineWidth = 4
        bezierPath2.stroke()
        
        context.restoreGState()
        if let image = context.makeImage() {
            return UIImage(cgImage: image)
        }
        else {return nil}
    }
    
}



class CombinerRenderView : UIView {
    var imageCombinerTemplate : ImageCombinerProtocol?
    var images : [UIImage]?
    override func draw(_ rect: CGRect) {
        
        if let template = imageCombinerTemplate , let imgs = self.images {
            template.setImages(images: imgs)
            template.drawAndGetCombiningResult(at: self.frame)
        }
    }
}
