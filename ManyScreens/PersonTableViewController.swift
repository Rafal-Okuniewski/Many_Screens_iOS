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
import CoreImage

class PersonTableViewController: UITableViewController {
    
    struct Section{
        let letter : String
        let names: [String]
    }

    var people = [Person]()
    var sections = [Section]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()
        loadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as? PersonTableViewCell else{
            fatalError("The dequeued cell is not an instance of PersonTableViewCell")
        }
        
        let person = people[indexPath.row]
        
        cell.labFullname.text = person.name + " " + person.surname
        cell.imgViewPhoto.image = UIImage(data:person.photo! as Data)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            os_log("Deleted", log: OSLog.default, type: .debug)
            people.remove(at: indexPath.row)
            sections.remove(at: indexPath.row)
            saveData()
           // tableView.deleteRows(at: [indexPath], with: .fade)
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
            } else {
                os_log("Adding a new person.", log: OSLog.default, type: .debug)
                // Add a new person
                let newIndexPath = IndexPath(row: people.count, section: 0)
                //let newPerson = Person(context: self.context)
                self.people.append(person)
                self.saveData()
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            people = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            os_log("Saved", log: OSLog.default, type: .debug)
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}
