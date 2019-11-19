//
//  MyNotesTableViewController.swift
//  MyNotes
//
//  Created by Mbadu, Edmond Ngoma on 11/19/19.
//  Copyright © 2019 Mbadu, Edmond Ngoma. All rights reserved.
//

import UIKit
import CoreData
class MyNotesTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
         self.tableView.rowHeight = 84.0

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // / fetch ShoppingLists from Core Data
    func loadNotes(){
        // Create an instance of a FetchRequest so that
        // ShoppingList can be fetched from Core Data
        let request: NSFetchRequest<Note> = Note.fetchRequest()
    
        do{
            // use context to execute a fetch request
            // to fetch ShoppingLists from Core Data
            // store the fetched ShoppingLists in our array
            notes = try context.fetch(request)
         
        } catch {
            print("Error fetching Notes from Core Data!")
        }
        
        // reload the fetched data in the Table View Controller
        tableView.reloadData()
    }
    
    // save shopping list into core Data
    func saveNotes(){
        do {
            // use context to save ShoppingLists into Core Data
            try context.save()
        }catch {
            print("Error saving Notes to Core Data!")
        }
        // reload the data in the Table View Controller
        tableView.reloadData()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

         // declare Text Fields variables for the input of the name, store, and data
             
             var titleTextField = UITextField()
             var typeTextField = UITextField()
//             var dateTextField = UITextField()
              
             
             // create an Alert Controller
             
             let alert = UIAlertController(title: "My Notes", message: "", preferredStyle: .alert)
         
         //define an action that will occur when the Add List button
             // is pushed
             let action = UIAlertAction(title: "Create ", style: .default, handler: { (action) in
                 
                 // create an instance of a ShoppingList entity
                 let newNote = Note (context: self.context)
                 
                 // get name, store, and date input by user and store them in ShoppingList entity
                 
                newNote.title = titleTextField.text!
                newNote.type = typeTextField.text!
//                 newNote.date = dateTextField.text!
                 
             
                 // add ShoppingListItem entity into array
                 self.notes.append(newNote)
                 
                 // save ShoppingListItems into Core Data
                 self.saveNotes()
                 
                 
             })
             
             // disable an action that will occure when the Cancel is pushed
             action.isEnabled = false
             // define an action that will occure when the Cancel is pushed
             let cancelAction = UIAlertAction (title: "Cancel", style: .default, handler: {(cancelAction) in
                 
             })
             
             alert.addAction(action)
             alert.addAction(cancelAction)
             
             // add the Text Field into Alert Controller
             
             alert.addTextField(configurationHandler: { (field) in
                 titleTextField = field
                 titleTextField.placeholder = "Title"
                 titleTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                 
             })
             
             alert.addTextField(configurationHandler: { (field) in
                       typeTextField = field
                      typeTextField.placeholder = "Type"
                  typeTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                       
                   })
//             alert.addTextField(configurationHandler: { (field) in
//                       timeTextField = field
//                       timeTextField.placeholder = "Time"
//              timeTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
//
//                   })
         
        
             
             //display the alert controller
             present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotesCell", for: indexPath)

        // Configure the cell...
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: String? = format.string(from: date)

        let note = notes[indexPath.row]
               cell.textLabel?.text = note.title!
               cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = "Type: " + note.type! + "\nCreated: " + formattedDate!
                     

        return cell
    }
    
    @objc func alertTextFieldDidChange (){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate: String? = format.string(from: date)
            // get a reference of the Alert Controller
            let alertController = self.presentedViewController as!
            UIAlertController
            
            // get a reference to the Action that allows the user to add a ShoppingList
            let action = alertController.actions[0]
            // get references to the  text in Text Fields
            if let title = alertController.textFields! [0].text,
                let type = alertController.textFields![1].text, let date = formattedDate
               {
                
                // trim whitespace from the text
                let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
                let trimmedType = type.trimmingCharacters(in: .whitespaces)
                let trimmedDate = date.trimmingCharacters(in: .whitespaces)
                
                // check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add a ShoppingList
                
                if(!trimmedTitle.isEmpty && !trimmedDate.isEmpty && !trimmedType.isEmpty ){
                action.isEnabled = true
                }
            }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
