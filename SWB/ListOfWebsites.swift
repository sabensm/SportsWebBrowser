//
//  ListOfWebsites.swift
//  SWB
//
//  Created by Sabens, Michael G. on 3/22/17.
//  Copyright © 2017 Sabens, Michael G. All rights reserved.
//

import UIKit

class ListOfWebsites: UITableViewController {
    
    let websites = supportedWebsites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select A Website To Load"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webview") as? WebViewVC {
            vc.urlToLoad = websites[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

}
