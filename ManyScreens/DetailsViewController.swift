//
//  DetailsViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import os.log

class DetailsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var imgViewAddPhoto: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var picBirth: UIDatePicker!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = person {
            txtName.text = person.name
            txtSurname.text = person.surname
            imgViewAddPhoto.image = person.photo
            picBirth.date = person.birth
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imgViewAddPhoto.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        txtName.resignFirstResponder()
        txtSurname.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIButton) {
        let isPresentingInAddPersonMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPersonMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DetailsViewController is not inside a navigation controller.")
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === btnSave else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = txtName.text ?? ""
        let surname = txtSurname.text ?? ""
        let birth = picBirth.date
        let photo = imgViewAddPhoto.image
        
        person = Person(name: name, surname: surname, birth: birth, photo: photo)
    }
    
}
