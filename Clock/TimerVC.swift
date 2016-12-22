//
//  TimerVC.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell") {
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "New Timer", message: "Enter timer name", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
