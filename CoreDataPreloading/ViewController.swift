//
//  ViewController.swift
//  CoreDataPreloading
//
//  Created by Pankaj on 16/01/19.
//  Copyright © 2019 Canarys Automations Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var tbleView: UITableView!
    private var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFetchedResultsController()
        
    }

    private func configureFetchedResultsController(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        do
        {
            try fetchResultsController?.performFetch()
            
        }catch{
            
            print(error.localizedDescription)
        }
        
    }

}
extension ViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("The Controller content has changed.")
        tbleView.reloadData()
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultsController?.sections else{
            return 0
        }
        let rowCount = sections[section].numberOfObjects
        print("THE AMMOUNT OF ROWS IN THE SECTION ARE: \(rowCount)")
        return rowCount
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let comany = fetchResultsController?.object(at: indexPath) as? Company{
            cell.textLabel?.text = comany.name
        }
        return cell
        
    }
}
