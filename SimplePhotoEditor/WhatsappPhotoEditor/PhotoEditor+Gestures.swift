//
//  PhotoEditor+Gestures.swift
//  QQPayment
//
//  Created by Mohamed saeed on 6/21/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.


import Foundation
import UIKit

extension PhotoEditorViewController : UIGestureRecognizerDelegate  {
    
    
    //UIPanGestureRecognizer - Moving Objects
     
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
                moveView(view: view, recognizer: recognizer)
        }
    }
    
  
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if view is UITextView {
                let textView = view as! UITextView
                
                if textView.font!.pointSize * recognizer.scale < 90 {
                    let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                    textView.font = font
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                } else {
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                }
                
                
                textView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }

    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    

    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
                scaleEffect(view: view)
        }
    }
    
    /*
     Support Multiple Gesture at the same time
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
   
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    func scaleEffect(view: UIView) {
        view.superview?.bringSubviewToFront(view)
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
                        }
        })
    }
    

    func moveView(view: UIView, recognizer: UIPanGestureRecognizer)  {
        
        
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)

        view.center = CGPoint(x: view.center.x + recognizer.translation(in: canvasImageView).x,
                              y: view.center.y + recognizer.translation(in: canvasImageView).y)
        
        recognizer.setTranslation(CGPoint.zero, in: canvasImageView)
        
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            lastPanPoint = nil
                if !canvasImageView.bounds.contains(view.center) { //Snap the view back to canvasImageView
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.canvasImageView.center
                })
                
            }
        }
    }
    
   
}
