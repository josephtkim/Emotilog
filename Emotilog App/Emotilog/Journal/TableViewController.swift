//
//  TableViewController.swift
//  Journal
//
//  Created by Isaac Kim on 6/10/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit


var entries = ["Happy", "Sad", "Angry", "Neutral", "Sad"]
var emotions = ["happy", "sad", "anger", "neutral", "sad"]
var dates = ["march 3, 2017", "april 3, 2017", "may 7, 2017", "june 1, 2017", "june 1, 2017"]

var myIndex = 0

class TableViewController: UITableViewController  {

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (entries.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewControllerTableViewCell
        
        cell.cellLabel.text = dates[indexPath.row]

        let imageString = "Emotion" + emotions[indexPath.row].capitalized + "_Striped_100.png"
        
        cell.cellImage.image = UIImage(named: imageString)
  
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "singleEntrySegue", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
