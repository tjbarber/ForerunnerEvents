//
//  ViewController.swift
//  TheHaloQuiz
//
//  Created by TJ Barber on 3/27/17.
//  Copyright © 2017 TJ Barber. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var questionLabels: [UILabel]!
    @IBOutlet var actionButtons: [UIButton]!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

    let eventProvider: HaloEventProvider
    let correctButtonImage: UIImage?
    let incorrectButtonImage: UIImage?
    let roundsPerGame: Int = 6
    
    var gameTimer: Timer?
    var countDown: Int = 60
    var currentRound: Int = 1
    var correctAnswers: Int = 0
    var inbetweenRounds: Bool = false
    var informationUrl: URL?

    required init?(coder aDecoder: NSCoder) {
        
        do {
            self.eventProvider = try HaloEventProvider(withEventFile: "EventData", ofType: "plist")
        } catch (let error) {
            fatalError("\(error)")
        }
        
        self.correctButtonImage = UIImage(named: "next_round_success")
        self.incorrectButtonImage = UIImage(named: "next_round_fail")

        super.init(coder: aDecoder)
    }
    
    // MARK: Override functions

    override func viewWillAppear(_ animated: Bool) {
        // put this in viewWillAppear because I don't want there to be white boxes as the events load
        // checking inbetweenRounds because I don't want this to run when the webview is dismissed
        if !inbetweenRounds {
            updateEvents()
            initiateCountdown()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) && !inbetweenRounds {
            checkAnswerAndUpdateDisplay(eventProvider.isOrderCorrect())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "scoreSegue":
                if let viewController = segue.destination as? ScoreViewController {
                    viewController.scoreString = "\(correctAnswers)/\(roundsPerGame)"
                }
            case "informationSegue":
                if let viewController = segue.destination as? InfoViewController, let url = informationUrl {
                    viewController.url = url
                }
            default: fatalError("unknown segue identifier")
            }
        }
    }
    
    // MARK: IBActions

    @IBAction func moveEvent(_ sender: UIButton) {
        if !inbetweenRounds {
            switch sender.tag {
            case 0, 1: eventProvider.rearrangeEventsBySwapping(firstEvent: 0, andSecondEvent: 1)
            case 2, 3:
                eventProvider.rearrangeEventsBySwapping(firstEvent: 1, andSecondEvent: 2)
            case 4, 5: eventProvider.rearrangeEventsBySwapping(firstEvent: 2, andSecondEvent: 3)
            default: fatalError("Hit a button that doesn't have a tag or one we don't expect")
            }
            
            updateEvents()
        }
    }
    
    @IBAction func startNextRound(_ sender: Any) {
        if currentRound == roundsPerGame {
            displayScore()
        } else {
            do {
                eventProvider.currentEventSet = try eventProvider.prepareNewEventSet()
            } catch (let description) {
                fatalError("\(description)")
            }
            
            currentRound += 1
            inbetweenRounds = false
            
            nextButton.isHidden = true
            nextButton.isUserInteractionEnabled = false
            
            instructionText.isHidden = false
            
            updateEvents()
            initiateCountdown()
        }
    }
    
    @IBAction func unwindToGame(segue: UIStoryboardSegue) {
        // starting a new game
        
        correctAnswers = 0
        currentRound = 1
        
        nextButton.isHidden = true
        nextButton.isUserInteractionEnabled = false
        
        updateEvents()
        initiateCountdown()
    }
    
    @IBAction func unwindFromInformation(segue: UIStoryboardSegue) {
        // all we need to do is unwind for now
    }
    
    @IBAction func eventTapped(_ sender: UITapGestureRecognizer) {
        if inbetweenRounds, let tag = sender.view?.tag {
            informationUrl = eventProvider.currentEventSet[tag].url
            performSegue(withIdentifier: "informationSegue", sender: self)
        }
    }
    
    // MARK: Game helper methods
    
    func updateEvents() {
        for index in 0...3 {
            let tag = questionLabels[index].tag
            questionLabels[index].text = eventProvider.currentEventSet[tag].description
        }
        
        instructionText.text = "Shake To Complete"
    }
    
    func displayScore() {
        performSegue(withIdentifier: "scoreSegue", sender: self)
    }
    
    func checkAnswerAndUpdateDisplay(_ answer: Bool) {
        inbetweenRounds = true
        self.instructionText.text = "Tap an event for more information."
        
        gameTimer?.invalidate()
        timerLabel.isHidden = true
        
        if answer {
            correctAnswers += 1
            nextButton.setBackgroundImage(correctButtonImage, for: .normal)
        } else {
            nextButton.setBackgroundImage(incorrectButtonImage, for: .normal)
        }
        
        nextButton.isHidden = false
        nextButton.isUserInteractionEnabled = true
    }
    
    // MARK: Timer methods
    
    func initiateCountdown() {
        countDown = 5
        timerLabel.text = "1:00"
        timerLabel.isHidden = false
        startTimer()
    }
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            (timer) in
            if self.countDown > 0 {
                self.countDown -= 1
                self.timerLabel.text = "\(self.countDown)"
            } else {
                // the countdown ran out, counts as wrong
                self.checkAnswerAndUpdateDisplay(false)
            }
        }
    }
}
