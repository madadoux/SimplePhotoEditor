//
//  ViewController.swift
//  SimplePhotoEditor
//
//  Created by Mohamed saeed on 6/21/20.
//  Copyright © 2020 Mohamed saeed. All rights reserved.


import UIKit
class ImagePickerViewController: UIViewController {
    
    var imageView: UIImageView!
    var importImage: UIButton!
    fileprivate func setupUI() {
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 40

        self.view.backgroundColor = .white
        imageView = UIImageView()
        imageView.image = .add
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120 + topPadding),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
            
        ])
        
        importImage = UIButton()
        importImage.setTitle("Import photo ..", for: .normal)
        importImage.setTitleColor(.blue, for: .normal)
        importImage.addTarget(self, action: #selector(pickImageButtonTapped), for: .touchUpInside)
        self.view.addSubview(importImage)
        importImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            importImage.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 50),
            importImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func pickImageButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension ImagePickerViewController: PhotoEditorDelegate {
    
    func doneEditing(image: UIImage) {
        imageView.image = image
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image = image
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext
        present(photoEditor, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


