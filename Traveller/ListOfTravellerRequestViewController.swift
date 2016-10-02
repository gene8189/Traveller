//
//  ListOfTravellerRequestViewController.swift
//  Traveller
//
//  Created by Tan Yee Gene on 02/10/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class ListOfTravellerRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListOfTravellerRequestTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
