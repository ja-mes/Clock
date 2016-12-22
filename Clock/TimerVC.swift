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
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let buttonPositon = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPositon) {
            let timer = controller.object(at: indexPath)
            
            let timerData = TimerData()
            present(timerData.saveAlert(timer: timer), animated: true, completion: nil)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let buttonPostion = sender.convert(CGPoint.zero, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            let timer = controller.object(at: indexPath)
            
            let timerData = TimerData()
            timerData.tick(with: timer)
        }
    }
    
    func configureCell(cell: TimerCell, indexPath: IndexPath) {
        let timer = controller.object(at: indexPath)
        
        if let name = timer.name {
            cell.nameLbl.text = "\(name)  - "
        }
        
    }
    
    func fetchTimers() {
        let fetchRequest: NSFetchRequest<TimerEntity> = TimerEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Unable to fetch timers: \(error)")
        }
    }
}















