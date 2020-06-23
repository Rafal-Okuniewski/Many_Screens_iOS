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
        var people: [Person]
    }

    var people = [Person]()
    var sections = [Section]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()
        loadData()
        let groupedDictionary = Dictionary(grouping: people, by: {String($0.surname.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{Section(letter: $0, people: groupedDictionary[$0]!)}
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as? PersonTableViewCell else{
            fatalError("The dequeued cell is not an instance of PersonTableViewCell")
        }
        
        let person = sections[indexPath.section].people[indexPath.row]
        cell.labFullname.text = person.name + " " + person.surname
        cell.imgViewPhoto.image = UIImage(data:person.photo! as Data)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            os_log("Deleted", log: OSLog.default, type: .debug)
            context.delete(sections[indexPath.section].people[indexPath.row])
            sections[indexPath.section].people.remove(at: indexPath.row)
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
            
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
            
            let selectedPerson = sections[indexPath.section].people[indexPath.row]
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
                os_log("Editing a person.", log: OSLog.default, type: .debug)
                sections[selectedIndexPath.section].people[selectedIndexPath.row] = person
                people[selectedIndexPath.row] = person
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                saveData()
            } else {
                os_log("Adding a new person.", log: OSLog.default, type: .debug)
                var contains = false
                var sectionId = 0
                for section in sections{
                    if(section.letter == person.surname.prefix(1)){
                        contains = true
                        break
                    }
                    sectionId += 1
                }
                if (contains) {
                    let newIndexPath = IndexPath(row: sections[sectionId].people.count, section: sectionId)
                    sections[sectionId].people.append(person)
                    people.append(person)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                } else {//TODO add new s
                    let newIndexPath = IndexPath(row: 0, section: sections.count)
                    var peopleConst = [Person]()
                    peopleConst.append(person)
                    sections.append(Section(letter: String(person.surname.prefix(1)), people: peopleConst))
                    people.append(person)
                    
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                self.saveData()
            }
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            people = try context.fetch(request)
            os_log("Data loaded.", log: OSLog.default, type: .debug)
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
            os_log("Data saved.", log: OSLog.default, type: .debug)
        } catch {
            print("Error saving data \(error)")
        }
    }

}
