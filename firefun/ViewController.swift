//
//  ViewController.swift
//  firefun
//
//  Created by Josh Moynihan on 6/26/17.
//  Copyright © 2017 Josh Moynihan. All rights reserved.
//


/*
 Database Structure
 
 {
    "form": {
        "1a2b3c4d":{
            "customer": "Siella Medical",
            "address": "123 example lane",
            "contact": "George Davis",
            "contactno": "123-456-7890",
            "facility": "Siella Facility",
            "model": "FK 1200",
            "manufr": "Google",
            "exterior": false,
            "powercord": false,
            "battery": false,
            "groundresistance": false,
            "chassisleakage": false,
            "leadleakage": false,
            "performanceverif": false,
            "note": "n/a",
            "lastpm": "01-01-2017",
            "nextpmdue": "02-02-2017",
            "testingperformedby": "George Davis"
        },
        "5e6f7g8h":{
             "customer": "Siella Medical",
             "address": "123 example lane",
             "contact": "George Davis",
             "contactno": "123-456-7890",
             "facility": "Siella Facility",
             "model": "FK 1200",
             "manufr": "Google",
             "exterior": false,
             "powercord": false,
             "battery": false,
             "groundresistance": false,
             "chassisleakage": false,
             "leadleakage": false,
             "performanceverif": false,
             "note": "n/a",
             "lastpm": "01-01-2017",
             "nextpmdue": "02-02-2017",
             "testingperformedby": "George Davis"
        }
    }
 }
 
 
 
 
 */

import UIKit
import FirebaseDatabase

var globalString = ""
var newForm = "False"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var myList:[String] = []
    var filteredData = [String]()
    var isSearching = false
    var myString = ""
    var handle:DatabaseHandle?
    
    @IBAction func createNewFormBtn(_ sender: Any) {
        //TODO - write create new form button that segues over to form view controller with empty fields
        newForm = "True"
        self.performSegue(withIdentifier: "openForm", sender: self)
    }
//    @IBAction func saveBtn(_ sender: Any) {
//        //Saving item to database
//        if (myTextField.text != "") {
//            ref?.child("list").childByAutoId().setValue(myTextField.text)
//            myTextField.text = ""
//        }
//        
//        
//    }
    
    
    
    //Setting up our table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
            cell.textLabel?.text = myList[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        //print(currentCell.textLabel!.text as! String)
        globalString = currentCell.textLabel!.text!
        self.performSegue(withIdentifier: "openForm", sender: self)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        print("text changed!")
    }
    
    //Hide keyboard when user clicks return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    //Hide keyboard when user clicks on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            //view.endEditing(true)
            myTableView.reloadData()
        } else {
            isSearching = true
            //filteredData = myList.filter({$0 == searchBar.text})
            filteredData = myList.filter{$0.range(of:searchBar.text!) != nil}
            myTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalString = ""
        newForm = "False"
        self.searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        //Establish connection to database
        ref = Database.database().reference()
        
        
        handle = ref?.child("forms").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.key as? String {
                //self.myList.append(item)
                //self.myTableView.reloadData()
                self.myString.append(item)
            }
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                if (rest.key == "model") {
                    //print(rest.value as! String)
                    self.myString.append(" ")
                    self.myString.append(rest.value as! String)
                }
                if (rest.key == "manufr"){
                    //print(rest.value as! String)
                    self.myString.append(" ")
                    self.myString.append(rest.value as! String)
                }
                
                //print (rest.value)
            }
            //print ("myString: " + self.myString)
            self.myList.append(self.myString)
            self.myTableView.reloadData()
            self.myString = ""
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

