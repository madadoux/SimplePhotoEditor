//
//  ViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/21/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.


import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
