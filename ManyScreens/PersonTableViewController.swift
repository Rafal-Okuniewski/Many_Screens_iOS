//
//  PersonTableViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import os.log
import CoreData

class PersonTableViewController: UITableViewController {
    
    struct Section{
        let letter : String
        let names: [String]
    }

    var people = [Person]()
    var sections = [Section]()
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()
        loadSampleData()
        //guard container != nil else {
        //    fatalError("This view needs a persistent container.")
       /// }
        let groupedDictionary = Dictionary(grouping: people.map({$0.surname}), by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{Section(letter: $0, names: groupedDictionary[$0]!.sorted())}
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell else{
            fatalError("The dequeued cell is not an instance of PersonTableViewCell")
        }
        
        let person = people[indexPath.section]
        
        cell.labFullname.text = person.name + " " + person.surname
        cell.imgViewPhoto.image = person.photo
        cell.accessoryType = .disclosureIndicator

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
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int ) -> String? {
       return sections[section].letter
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int ) -> String? {
        return "End of letter: " + sections[section].letter
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
        if let nextVC = segue.destination as? DetailsViewController {
            nextVC.container = container
        }
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
        }
    }
    
    private func loadSampleData(){
        let photo1 = UIImage(named: "avatar1")
        let photo2 = UIImage(named: "avatar2")
        let photo3 = UIImage(named: "avatar3")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        guard let person1 = Person(name: "Oliver", surname: "Smith", birth: formatter.date(from: "1977/11/03") ?? Date.init(), photo: photo1) else {
            fatalError("Unable to create person1")
        }
        
        guard let person2 = Person(name: "Jack", surname: "Williams", birth: formatter.date(from: "1990/01/20") ?? Date.init(), photo: photo2) else {
            fatalError("Unable to create person2")
        }
        
        guard let person3 = Person(name: "Amelia", surname: "Jones", birth: formatter.date(from: "1985/06/17") ?? Date.init(), photo: photo3) else {
            fatalError("Unable to create person3")
        }

        people += [person1, person2, person3]
        people.sort(by: {$0.surname < $1.surname})
    }
    
}
