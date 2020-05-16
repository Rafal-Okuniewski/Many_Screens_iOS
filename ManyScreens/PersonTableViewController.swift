//
//  PersonTableViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import os.log

class PersonTableViewController: UITableViewController {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()
        // Load any saved people, otherwise load sample data.
        if let savedPeople = loadPeople() {
            people += savedPeople
        }        else{
            loadSampleData()
        }
        UserDefaults.standard.register(defaults: [String:Any]())
        userSettings()
    }
    
    private func userSettings(){
        let userDefaults = UserDefaults.standard
        let userName = userDefaults.string(forKey: "user_name")
        let userSurname = userDefaults.string(forKey: "user_surname")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        let alertController = UIAlertController(title: "Welcome", message: "Hello " + userName! + " " + userSurname! + " today is " + dayInWeek + ".", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK",style: .default,handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell else{
            fatalError("The dequeued cell is not an instance of PersonTableViewCell")
        }
        
        let person = people[indexPath.row]
        
        cell.labFullname.text = person.name + " " + person.surname
        cell.imgViewPhoto.image = person.photo
        
        let appDefaults = UserDefaults.standard
        let appFont = appDefaults.float(forKey: "app_font_size")
        cell.labFullname.font = cell.labFullname.font.withSize(CGFloat(appFont))

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            people.remove(at: indexPath.row)
            savePeople()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new person.", log: OSLog.default, type: .debug)
        case "ShowDetails":
            guard let detailsViewController = segue.destination as? DetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPersonCell = sender as? PersonTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPersonCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPerson = people[indexPath.row]
            detailsViewController.person = selectedPerson
            
        case "":
            os_log("Opening popup window.", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToPeopleList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailsViewController, let person = sourceViewController.person {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing person
                people[selectedIndexPath.row] = person
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new person
                let newIndexPath = IndexPath(row: people.count, section: 0)
                people.append(person)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            savePeople()
        }
    }
    
    private func loadSampleData(){
        let photo1 = UIImage(named: "avatar1")
        let photo2 = UIImage(named: "avatar2")
        let photo3 = UIImage(named: "avatar3")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        guard let person1 = Person(name: "Oliver", surname: "Smith", birth: formatter.date(from: "1977/11/03") ?? Date.init(), photo: photo1) else {
            fatalError("Unable to create person 1")
        }
        
        guard let person2 = Person(name: "Jack", surname: "Williams", birth: formatter.date(from: "1990/01/20") ?? Date.init(), photo: photo2) else {
            fatalError("Unable to create person 2")
        }
        
        guard let person3 = Person(name: "Amelia", surname: "Jones", birth: formatter.date(from: "1985/06/17") ?? Date.init(), photo: photo3) else {
            fatalError("Unable to create person 3")
        }

        people += [person1, person2, person3]
    }
    
    private func savePeople() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(people, toFile: Person.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("People successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save people...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPeople() -> [Person]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
    }
    
}
