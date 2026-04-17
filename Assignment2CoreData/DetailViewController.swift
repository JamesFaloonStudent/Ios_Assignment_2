//
//  DetailViewController.swift
//  Assignment2CoreData
//
//  Created by James Faloon on 2026-04-17.
//

import UIKit

class DetailViewController: UIViewController {
    
    // This will hold the data passed from the first screen
    var selectedMessage: Message?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Message Detail"
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100))
        label.numberOfLines = 0
        label.textAlignment = .center
        
        // Display the message text
        label.text = selectedMessage?.message
        
        view.addSubview(label)
    }
}
