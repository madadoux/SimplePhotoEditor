//
//  ViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/21/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.


import UIKit

func combine(images: UIImage...) -> UIImage? {
    var contextSize = CGSize.zero
    
    for image in images {
        contextSize  = CGSize(width:max(contextSize.width, image.size.width) , height:max(contextSize.height, image.size.height) )
    }
    
    UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
    
    for image in images {
        let originX = (contextSize.width - image.size.width) / 2
        let originY = (contextSize.height - image.size.height) / 2
        
        image.draw(in: CGRect(x: originX, y: originY,  width:  image.size.width, height:  image.size.height))
    }
    
    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return combinedImage
}

extension UIImage {
    func imageByApplyingClippingBezierPath(_ path: UIBezierPath) -> UIImage? {
        // Mask image using path
        guard let maskedImage = imageByApplyingMaskingBezierPath(path) else { return nil }
        
        // Crop image to frame of path
        let croppedImage = UIImage(cgImage: maskedImage.cgImage!.cropping(to: path.bounds)!)
        
        return croppedImage
    }
    
    func imageByApplyingMaskingBezierPath(_ path: UIBezierPath) -> UIImage? {
        // Define graphic context (canvas) to paint on
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        // Set the clipping mask
        path.addClip()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        guard let maskedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        // Restore previous drawing context
        context.restoreGState()
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
    
    func clip(_ path: UIBezierPath) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        self.draw(in: frame)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        context?.restoreGState()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class CombineImagesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let myview = CombinerRenderView()
        // you can always change your template any time (DI)
        myview.imageCombinerTemplate = ImageCombiner2ImagesTemplate1()
        myview.images = [UIImage(named: "image1")!,UIImage(named: "image2")!]
        myview.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height/3)
        view.addSubview(myview)
        
    }
    
    
    func testClippingImage() {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
        let path = UIBezierPath()
        let frame = self.view.bounds
        let size =  UIImage(named: "me")!.size
        print(size)
        print(frame)
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: 0.0, y: size.height))
        
        // Create the bottom line (bottom-left to bottom-right).
        path.addLine(to: CGPoint(x: size.width * 0.65, y: size.height))
        
        path.addLine(to: CGPoint(x: size.width * 0.35 , y: 0))
        
        path.close()
        imageView.image = UIImage(named: "me")?.imageByApplyingClippingBezierPath(path)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
