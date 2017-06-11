//
//  ViewController.swift
//  Journal
//
//  Created by Isaac Kim on 6/9/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Emotion keyword matches
    let joyKeywords: [String] = ["glad", "happy", "good", "great", "awesome"]
    let sadKeywords: [String] = ["sad", "awful", "depressed", "afraid", "lonely"]
    let angryKeywords: [String] = ["angry", "mad", "frustrated", "annoyed", "irritated"]
    let neutralKeywords: [String] = ["fine", "okay", "nothing", "neutral"]

    // Entry
    // mood, entry, date
    struct journalEntry {
        var mood: String
        var entry: String
        var date: String
    }
    
    // Progress = Ask mood -> Save mood -> Ask followup -> Save entry text -> Save new entry? Y/N/Restart - Save journal/Go back to home/Start entry over
    
    
    @IBAction func NewEntry(_ sender: UIButton) {
        
    }
    
    
    
}

