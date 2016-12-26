//
//  TimerVC.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import CoreData

class TimerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<TimerEntity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTimers()
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell") as? TimerCell {
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath)
        print(destinationIndexPath)
        
//        fetchTimers()
//        
//        var objects = self.controller.fetchedObjects!
//        self.controller.delegate = nil
//        
//        let object = objects[sourceIndexPath.row]
//        objects.remove(at: sourceIndexPath.row)
//        objects.insert(object, at: destinationIndexPath.row)
//        
//        var i = 0
//        for object in objects {
//            i += 1
//            object.position = Int32(i)
//        }
//        
//        appDel.saveContext()
//        
//        self.controller.delegate = self
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? TimerCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let timerData = TimerData()
        present(timerData.saveAlert(), animated: true, completion: nil)
    }
    
    @IBAction func editTableViewButtonPressed(_ sender: UIButton) {
        if tableView.isEditing {
            sender.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let buttonPositon = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPositon) {
            let timer = controller.object(at: indexPath)
            
            let timerData = TimerData()
            present(timerData.saveAlert(timer: timer), animated: true, completion: nil)
        }
    }
    
    
    func configureCell(cell: TimerCell, indexPath: IndexPath) {
        let timer = controller.object(at: indexPath)
        
        cell.timerEntity = timer
        
        if timer.isRunning, let startDate = timer.startDate {
            let secondsInt = Int(Date().timeIntervalSince(startDate as Date).rounded())
            let breakDown = secondsToHoursMinutesSeconds(seconds: secondsInt)
            
            var hours = "\(breakDown.0)"
            if breakDown.0 < 10 {
                hours = "0\(breakDown.0)"
            }
            
            var minutes = "\(breakDown.1)"
            if breakDown.1 < 10 {
                minutes = "0\(breakDown.1)"
            }
            
            var seconds = "\(breakDown.2)"
            if breakDown.2 < 10 {
                seconds = "0\(breakDown.2)"
            }
            
            
            
            cell.timeLbl.text = "\(hours):\(minutes):\(seconds)"
        } else {
            cell.timeLbl.text = "0:00"
        }
        
        if let name = timer.name {
            cell.nameLbl.text = "\(name)  - "
        }
        
    }
    
    func fetchTimers() {
        let fetchRequest: NSFetchRequest<TimerEntity> = TimerEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Unable to fetch timers: \(error)")
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}















