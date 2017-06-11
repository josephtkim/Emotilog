//
//  SingleEntryViewController.swift
//  Journal
//
//  Created by Isaac Kim on 6/10/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit

class SingleEntryViewController: UIViewController {

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func backToEntriesButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToEntriesSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        entryTextView.text = entries[myIndex]
        entryDateLabel.text = dates[myIndex]
        entryImageView.image = UIImage(named: String("Emotion" + emotions[myIndex].capitalized + "_300.png"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
