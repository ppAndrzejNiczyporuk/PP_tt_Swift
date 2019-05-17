//
//  ParcelListViewController.swift
//  tt
//
//  Created by programista on 12/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import UIKit
import CoreData

class ParcelsTableViewController: UITableViewController  {
    //var parcels: [PPParcel] = [] //= [PPParcel(n: "testp0")]
    fileprivate lazy var stack: CoreDataStack = CoreDataStack(modelName:"ParcelDataModel")
    
    fileprivate lazy var parcels: NSFetchedResultsController<PPParcel> = {
        let context = self.stack.managedContext
        let request = PPParcel.fetchRequest() as! NSFetchRequest<PPParcel>
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(PPParcel.numer), ascending: false)]
        
        let parcels = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        parcels.delegate = self
        return parcels
    }()
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
             try parcels.performFetch()
            
        } catch {
            print("Error: \(error)")
        }

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parcels"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ParcelCell")

    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let parcelEntity = NSEntityDescription.entity(forEntityName: "PPParcel", in: self.stack.managedContext)!
        let alert = UIAlertController(title: "New Parcel",
                                      message: "Add a number of  parcel",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                        let nameToSave = textField.text else {return }
             
                                        let parcel = NSManagedObject(entity: parcelEntity, insertInto: self.stack.managedContext)
                                        parcel.setValue(nameToSave, forKey: "numer")
                                        
                                        do {
                                            try self.stack.managedContext.save()
                                        } catch let error as NSError {
                                            print("Error saving \(error)", terminator: "")
                                        }
                        
                                        //self.parcels.append(PPParcel(n:nameToSave))
                                       // self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: false)
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
            detailView.parcel = parcels.object(at: indexPath)
        }
        
    }

}
extension ParcelsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objects = parcels.fetchedObjects
        return objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // let cell: ParcelTableViewCell
    //let cell = tableView.dequeueReusableCell(withIdentifier: "ParcelCell",for: indexPath) //as! ParcelTableViewCell
    let cell = tableView.dequeueReusableCell(withIdentifier: "ParcelCell",for: indexPath) //	as! ParcelTableViewCell
   // cell.parcel = parcels.object(at: indexPath)
   cell.textLabel?.text = parcels.object(at: indexPath).numer
   return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showParcelDetail", sender: cell)
     
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
         //   tableView.deleteRows(at: [indexPath], with: .fade)
            guard  editingStyle == .delete else { return }
            
            let parcelToRemove = parcels.object(at: indexPath)
            self.stack.managedContext.delete(parcelToRemove)
            
            do {
                try self.stack.managedContext.save()
               // tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print("Deleting error: \(error), description: \(error.userInfo)")
            }

        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ParcelsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! ParcelTableViewCell
            cell.parcel = parcels.object(at: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
       default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}
