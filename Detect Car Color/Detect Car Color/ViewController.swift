//
//  ViewController.swift
//  Detect Car Color
//
//  Created by Elias Heffan on 2/20/20.
//  Copyright © 2020 Plate OCR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var dominantColorLabel: UILabel!
    @IBOutlet weak var secondDominantColorLabel: UILabel!
    @IBOutlet weak var thirdDominantColorLabel: UILabel!
    
    @IBOutlet weak var pickImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func onClickPickImage() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// Deals with what to do after a user chooses an image
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image

            pickImageButton.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            image.determineDominantColor { colors in
                self.dominantColorLabel.backgroundColor = colors[0]
                self.secondDominantColorLabel.backgroundColor = colors[1]
                self.thirdDominantColorLabel.backgroundColor = colors[2]
                self.activityIndicator.stopAnimating()
                self.pickImageButton.isUserInteractionEnabled = true
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
