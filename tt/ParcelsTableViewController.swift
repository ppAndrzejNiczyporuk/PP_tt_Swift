//
//  ParcelListViewController.swift
//  tt
//
//  Created by programista on 12/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import UIKit

class ParcelsTableViewController: UITableViewController {
    var parcels: [PPParcel] = [] //= [PPParcel(n: "testp0")]
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Parcel",
                                      message: "Add a number of  parcel",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {return }
                                        self.parcels.append(PPParcel(n:nameToSave))
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parcels"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        importJSONParcelData()  //import test data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showParcelDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let controller = segue.destination as! ParcelDetailViewController
//                 print("Set in segue  \(parcels[indexPath.row].number)"  ) //TODO obsługa wybrania
//            }
//        }
        if let detailView = segue.destination as? ParcelDisplayable,
            let indexPath = tableView.indexPathForSelectedRow {
            detailView.parcel = parcels[indexPath.row]
        }
        
    }
    func importJSONParcelData() {
        
        let jsonURL = Bundle.main.url(forResource: "parcels", withExtension: "json")!
        let jsonData = NSData(contentsOf: jsonURL)! as Data
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [AnyObject]
            
            for jsonDictionary in jsonArray {
                let number  = jsonDictionary["number"] as! String
                
                parcels.append(PPParcel(n: number))
            }
            
            print("Imported \(jsonArray.count) parcel")
            
        } catch let error as NSError {
            print("Error importing parcel: \(error)")
        }
    }
}
extension ParcelsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return parcels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
       cell.textLabel?.text = parcels[indexPath.row].number
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showParcelDetail", sender: cell)
       // print("TODO select \(indexPath.row)"  )
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //TODO obsługa wybrania
            parcels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}

