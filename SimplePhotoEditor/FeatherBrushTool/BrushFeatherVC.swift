//
//  BrushFeatherViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/26/20.
//

import UIKit

class BrushFeatherVC: UIViewController {
    
    @IBOutlet weak var imageView: DrawableImageView!
    @IBOutlet weak var blurImageView : UIImageView!
    @IBOutlet weak var effectButton : UIButton!
    
    let image = UIImage(named: "image1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        effectButton.addTarget(self, action: #selector(brushEffect), for: .touchUpInside)
        imageView.image = image
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @objc func brushEffect(){
        
        let size1 = imageView.bounds.size
        let bezierPath = imageView.path
        
        imageView.reset()
       // imageView.image =  imageView.cropImage()
        //           bezierPath.move(to: CGPoint(x: 10, y: 10))
        //           bezierPath.addLine(to: CGPoint(x: 10, y: size1.height - 10))
        //           bezierPath.addLine(to: CGPoint(x: size1.width - 10, y: size1.height - 10 ))
        //           bezierPath.addLine(to: CGPoint(x: size1.width - 10, y: 10))
        //
        //           bezierPath.close()
        
        
        let shape = CAShapeLayer()
        shape.frame = imageView.frame
        shape.path = bezierPath.cgPath
        shape.fillColor = UIColor.red.cgColor
        shape.backgroundColor = UIColor.clear.cgColor
        let shapeImage = UIGraphicsImageRenderer(size: imageView.bounds.size).image { context in
            context.cgContext.move(to: CGPoint(x: 0, y: 0))
            shape.render(in: context.cgContext)
        }
        // imageView.layer.mask = (shape)
        
        let shapeCimage = CIImage(image: shapeImage)
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")!
        gaussianBlurFilter.setValue(shapeCimage, forKey: "inputImage")
        gaussianBlurFilter.setValue(NSNumber(value: 20), forKey: "inputRadius")
        if let ciImage = gaussianBlurFilter.value(forKey: "outputImage") as?  CIImage {
            let blurredImage = UIImage(ciImage: ciImage)
            
            let maskView = UIImageView(image: blurredImage)
            //maskView.contentMode = .scaleAspectFit
            maskView.frame = imageView.bounds
            imageView.mask = maskView
            
            
            blurImageView.image = blurredImage
            
        }
    }
    
    func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        
        let maskRef = maskImage.cgImage
        
        let mask = CGImage(
            maskWidth: maskRef!.width,
            height: maskRef!.height,
            bitsPerComponent: maskRef!.bitsPerComponent,
            bitsPerPixel: maskRef!.bitsPerPixel,
            bytesPerRow: maskRef!.bytesPerRow,
            provider: maskRef!.dataProvider!,
            decode: nil,
            shouldInterpolate: false)
        
        let masked = image.cgImage!.masking(mask!)
        let maskedImage = UIImage(cgImage: masked!)
        
        // No need to release. Core Foundation objects are automatically memory managed.
        
        return maskedImage
        
    }
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
}
