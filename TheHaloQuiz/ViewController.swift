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
    
    let eventProvider: HaloEventProvider

    required init?(coder aDecoder: NSCoder) {
        do {
            self.eventProvider = try HaloEventProvider()
        } catch (let error) {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    // create initializer that loads HaloEventProvider

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
            case 0, 1: eventProvider.rearrangeEventsBySwapping(firstEvent: 0, andSecondEvent: 1)
            case 2, 3: eventProvider.rearrangeEventsBySwapping(firstEvent: 1, andSecondEvent: 2)
            case 4, 5: eventProvider.rearrangeEventsBySwapping(firstEvent: 2, andSecondEvent: 3)
            default: fatalError("Hit a button that doesn't have a tag or one we don't expect")
        }

        updateEvents()
    }

    func updateEvents() {
        var index = 0

        for label in questionLabels {
            label.text = eventProvider.currentEventSet[index].description
            index += 1
        }
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            print(eventProvider.isOrderCorrect())
        }
    }
}
