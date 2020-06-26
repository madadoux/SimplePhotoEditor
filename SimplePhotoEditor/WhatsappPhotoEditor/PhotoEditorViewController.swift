//
//  ViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/22/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.


import UIKit
import ColorSlider
public protocol PhotoEditorDelegate {
    func doneEditing(image: UIImage)
    func canceledEditing()
}

public extension UIColor {
    
    //MARK: - Public method
    
    /**
     Creates UIColor object based on given HSL values.
     
     - parameter hue: CGFloat with the hue value. Hue value must be between 0 and 360.
     - parameter saturation: CGFloat with the saturation value. Saturation value must be between 0 and 1.
     - parameter lightness: CGFloat with the lightness value. Lightness value must be between 0 and 1.
     
     - returns: A UIColor from the given HSL values.
     */
    @objc(hsl_colorWithHue:saturation:lightness:)
    public class func colorWithHSL(hue hue: CGFloat, saturation: CGFloat, lightness: CGFloat) -> UIColor? {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        guard hue <= 360 && hue >= 0.0 else { return nil }
        guard saturation <= 1.0 && saturation >= 0.0 else { return nil }
        guard lightness <= 1.0 && lightness >= 0.0 else { return nil }
        
        let chroma: CGFloat = (1 - abs((2 * lightness) - 1)) * saturation
        let h60: CGFloat = hue / 60.0
        let x: CGFloat = chroma * (1 - abs((h60.truncatingRemainder(dividingBy:  2)) - 1))
        
        if (h60 < 1) {
            
            r = chroma
            g = x
        }
        else if (h60 < 2)
        {
            r = x
            g = chroma
        }
        else if (h60 < 3)
        {
            g = chroma
            b = x
        }
        else if (h60 < 4)
        {
            g = x
            b = chroma
        }
        else if (h60 < 5)
        {
            r = x
            b = chroma
        }
        else if (h60 < 6)
        {
            r = chroma
            b = x
        }
        
        let m: CGFloat = lightness - (chroma / 2)
        
        r = r + m
        g = g + m
        b = b + m
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

public final class PhotoEditorViewController: UIViewController {
    
    /** holding the 2 imageViews original image and drawing & stickers */
    @IBOutlet weak var canvasView: UIView!
    //To hold the image
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    //To hold the drawings and stickers
    @IBOutlet weak var canvasImageView: UIImageView!
    
        
    //Controls
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var colorSlider: UISlider!
    var externalColorSlider : ColorSlider!
    public var image: UIImage?
    
    public var photoEditorDelegate: PhotoEditorDelegate?
    
    
    var textColor: UIColor = UIColor.white
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var isTyping: Bool = false
    var isDrawing = false
    
    
    public override func loadView() {
        super.loadView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setImageView(image: image!)
        setupUI()
        colorSlider.addTarget(self, action: #selector(colorSliderChanged), for: .valueChanged)
        colorSlider.isHidden = true
        
    }
    
    func setupUI() {
        externalColorSlider = ColorSlider(orientation: .vertical, previewSide: .left)
        externalColorSlider.frame = CGRect(x: self.view.frame.width - 40, y: 50, width: 20, height: 300)
        canvasView.addSubview(externalColorSlider)
       
        externalColorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        externalColorSlider.isHidden = true
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        if let textView = activeTextView {
            textView.textColor = color
        }
    }
    
    @objc func colorSliderChanged( _ sender: UIControl) {
        let hue =  colorSlider.value * 360
        let color = UIColor.colorWithHSL(hue: CGFloat(hue), saturation: 1.0, lightness: 0.7)
        colorSlider.thumbTintColor = color
        if let textView = activeTextView {
            textView.textColor = color
        }
    }
    
    
    func setImageView(image: UIImage) {
        imageView.image = image
        let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        imageViewHeightConstraint.constant = (size?.height)!
    }
        
    @IBAction func textButtonTapped(_ sender: Any) {
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 50))
        activeTextView = textView
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        colorSlider.isHidden = false
        externalColorSlider.isHidden = false
        textView.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        externalColorSlider.isHidden = true
        colorSlider.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        isDrawing = false
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(PhotoEditorViewController.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(PhotoEditorViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoEditorViewController.tapGesture))
        view.addGestureRecognizer(tapGesture)
        
    }
}





extension PhotoEditorViewController : UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if ( text.contains("\n")) {
            textView.resignFirstResponder()
            colorSlider.isHidden = true
            externalColorSlider.isHidden = true 
            return false
        }
        return true
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        print("end editing")
        activeTextView = nil
    }
}
