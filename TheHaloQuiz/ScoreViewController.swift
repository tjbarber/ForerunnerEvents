//
//  ScoreViewController.swift
//  TheHaloQuiz
//
//  Created by TJ Barber on 4/4/17.
//  Copyright © 2017 TJ Barber. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scoreString: String?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scoreLabel.text = scoreString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAgain(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToGame", sender: self)
    }

}
