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
        
        for label in questionLabels {
            label.isHidden = false
        }
        
        for button in actionButtons {
            button.isHidden = false
            button.isUserInteractionEnabled = true
        }
    }

}

