//
//  InfoViewController.swift
//  TheHaloQuiz
//
//  Created by TJ Barber on 4/5/17.
//  Copyright © 2017 TJ Barber. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var url: URL?

    @IBOutlet weak var informationWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let pageRequest = URLRequest(url: url)
            informationWebView.loadRequest(pageRequest)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeInformationView(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromInformation", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
