//
//  ViewController.swift
//  mcamera
//
//  Created by Roman Sukner on 17/11/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var screenShot: UIImageView!
    @IBOutlet weak var screenShotDestination: UIImageView!
    @IBOutlet weak var txtBase64: UITextView!
    @IBOutlet weak var lblBeforeCompression: UILabel!
    @IBOutlet weak var lblAfterCompression: UILabel!

    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
        
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
            case .camera:
                imagePicker.sourceType = .camera
            case .photoLibrary:
                imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - Saving Image here
    @IBAction func saveOriginalImage(_ sender: AnyObject) {
        guard let selectedImage = screenShot.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @IBAction func saveCompressedImage(_ sender: AnyObject) {
        guard let selectedImage = screenShotDestination.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
      
}

extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        if let imageSize = selectedImage.imageSize() {            
            screenShot.image = selectedImage
            lblBeforeCompression.text = "\(imageSize/1024) kb"
        }
        
        if let imageData = selectedImage.max_compressImage(toMaxLength: .k50, maxWidth: 640) {
            lblAfterCompression.text = "\(imageData.count/1024) kb"
            txtBase64.text = imageData.base64EncodedString(options: .lineLength64Characters)
            screenShotDestination.image = UIImage.init(data:imageData)
        }
        
    }
}

