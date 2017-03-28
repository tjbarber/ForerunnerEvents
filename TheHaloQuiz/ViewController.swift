//
//  ViewController.swift
//  TheHaloQuiz
//
//  Created by TJ Barber on 3/27/17.
//  Copyright © 2017 TJ Barber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var questionLabels: [UILabel]!
    @IBOutlet var actionButtons: [UIButton]!
    @IBOutlet weak var instructionText: UILabel!
    
    var events = ["Destruction of the first Halo installation", "Cortana's Death", "UNSC recovers the Master Chief", "The Covenant attacks Earth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startGame() {
        startButton.isHidden = true
        startButton.isUserInteractionEnabled = false
        instructionText.isHidden = false
        
        
        for label in questionLabels {
            label.isHidden = false
        }
        
        for button in actionButtons {
            button.isHidden = false
            button.isUserInteractionEnabled = true
        }
        
        updateEvents()
    }

    @IBAction func moveEvent(_ sender: UIButton) {
        switch sender.tag {
            case 0, 1: rearrangeEventsBySwapping(index: 0, and: 1)
            case 2, 3: rearrangeEventsBySwapping(index: 1, and: 2)
            case 4, 5: rearrangeEventsBySwapping(index: 2, and: 3)
            default: fatalError("Hit a button that doesn't have a tag or one we don't expect")
        }
    }
    
    func updateEvents() {
        var index = 0
        
        for label in questionLabels {
            label.text = events[index]
            index += 1
        }
    }
    
    func rearrangeEventsBySwapping(index firstIndex: Int, and secondIndex: Int) {
        let event1 = events[firstIndex]
        let event2 = events[secondIndex]
        
        events[secondIndex] = event1
        events[firstIndex] = event2
        
        updateEvents()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            print("works")
        }
    }
}

