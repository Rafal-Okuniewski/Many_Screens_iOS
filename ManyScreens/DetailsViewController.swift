//
//  DetailsViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import os.log
import CoreData

class DetailsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var imgViewAddPhoto: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var picBirth: UIDatePicker!
    
    var person: Person?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        if let person = person {
            txtName.text = person.name
            txtSurname.text = person.surname
            imgViewAddPhoto.image = UIImage(data:person.photo! as Data)
            picBirth.date = person.birth as Date
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
        guard let button = sender as? UIButton, button === btnOk else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if person != nil {
            person!.name = txtName.text ?? ""
            person!.surname = txtSurname.text ?? ""
            person!.birth = picBirth.date as NSDate
            person!.photo = imgViewAddPhoto.image?.pngData()! as NSData?
        } else {
            let newPerson = Person(context: self.context)
            newPerson.name = txtName.text ?? ""
            newPerson.surname = txtSurname.text ?? ""
            newPerson.birth = picBirth.date as NSDate
            newPerson.photo = imgViewAddPhoto.image?.pngData()! as NSData?
            person = newPerson
        }
    }

}
