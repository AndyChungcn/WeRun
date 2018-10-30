//
//  RunLogTVC.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/29.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit

class RunLogTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

}

extension RunLogTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
