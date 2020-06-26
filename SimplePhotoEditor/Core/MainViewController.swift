//
//  MainViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/25/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0, borderColor : UIColor = .blue , borderWidth : CGFloat = 3 ) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
        subView.layer.borderColor = borderColor.cgColor
        subView.layer.borderWidth = borderWidth
    }
}

class MainViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Please Choose Assignment"
        let imageCombinerButton = DUTextButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30), title: "Image Combiner >", textColor: .black, textFont: .  boldSystemFont(ofSize: 22), onTap: {
            let imageCombVc = CombineImagesViewController()
            self.navigationController?.pushViewController(imageCombVc, animated: true)
            
        })
        imageCombinerButton.setImage(.add, for: .normal)
        
        let whatsAppEditorButton = DUTextButton(frame: .zero, title: "WhatsApp Editor >", textColor: .black, textFont: .boldSystemFont(ofSize: 22), onTap: {
            let whatsAppEditor = ImagePickerViewController()
            self.navigationController?.pushViewController(whatsAppEditor, animated: true)
            
        })
        
        whatsAppEditorButton.setImage(.add, for: .normal)

        let brushFeather = DUTextButton(frame: .zero, title: "Brush Feather >", textColor: .black, textFont: .boldSystemFont(ofSize: 22), onTap: {
            
                  let brushFeatherController = BrushFeatherVC(nibName:"BrushFeatherViewController",bundle: Bundle(for: BrushFeatherVC.self))
                  brushFeatherController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                  self.navigationController?.pushViewController(brushFeatherController, animated: true)
            
            })
            
            brushFeather.setImage(.add, for: .normal)

        let column = DUColumn(frame: .zero, children: [
            imageCombinerButton,
            whatsAppEditorButton,
            brushFeather
        ], distribution: .fill, alignment: .leading, spacing: 20)
        
        self.view.addSubview(column)
        column.translatesAutoresizingMaskIntoConstraints = false
        //column.customize()
        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            column.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.7),
            column.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)

            
        ])
        
        
    }
}
