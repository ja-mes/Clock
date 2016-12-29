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
    
    lazy var timerData = TimerData.shared
    var controller: NSFetchedResultsController<TimerEntity>!
    var timer: Timer!
    
    var shouldStrinkLabels = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTimers()
        startTimer()
        
        if self.view.frame.size.width <= 320 {
            shouldStrinkLabels = true
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing {
            return true
        } 
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        controller.delegate = nil
        
        if var objects = controller.fetchedObjects {
            let object = objects[sourceIndexPath.row]
            objects.remove(at: sourceIndexPath.row)
            objects.insert(object, at: destinationIndexPath.row)
            
            var i: Int32 = 0
            for object in objects {
                i += 1
                object.position = i
                
            }
            
            appDel.saveContext()
        }
        
        controller.delegate = self
        
        fetchTimers()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(controller.object(at: indexPath))
            appDel.saveContext()
        }
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
            startTimer()
            sender.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
        } else {
            timer.invalidate()
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
        
        if shouldStrinkLabels {
            cell.timeLbl.font = UIFont(name: cell.timeLbl.font.fontName, size: 40)
        }
        
        if timer.isRunning, let startDate = timer.startDate {
            let secondsInt = Int(Date().timeIntervalSince(startDate as Date).rounded())
            cell.timeLbl.text = timerData.secondsToTimeString(seconds: secondsInt)

            cell.changeButton(start: false)
            
        } else if let startDate = timer.startDate, let pauseDate = timer.pauseDate {
            let timeOnTimer = Int(timerData.calculateTimeWhenPaused(startDate: startDate, pauseDate: pauseDate))
            
            cell.timeLbl.text = timerData.secondsToTimeString(seconds: Int(timeOnTimer))
            cell.changeButton(start: true)
        } else {
            cell.timeLbl.text = "00:00:00"
            cell.changeButton(start: true)
        }
        
        cell.nameLbl.text = timer.name
        
    }
    
    func fetchTimers() {
        let fetchRequest: NSFetchRequest<TimerEntity> = TimerEntity.fetchRequest()
        
        let postionSort = NSSortDescriptor(key: "position", ascending: true)
        let dateSort = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [postionSort, dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Unable to fetch timers: \(error)")
        }
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
}















