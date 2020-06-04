//
//  StopWatchViewController.swift
//  ios-clock
//
//  Created by Carlos andres Diaz bravo  on 2020-06-03.
//

import UIKit

class StopWatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var timer  = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    
    var  stopwatchString: String = ""
    var startStopWatch: Bool = true
    var addLap: Bool = false

    @IBOutlet weak var stopwatchLabel: UILabel!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var startstopButton: UIButton!
    
    @IBOutlet weak var lapresetButton: UIButton!
    
    @IBAction func startStop(_ sender: Any) {
        if startStopWatch == true {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateStopwatch), userInfo: nil, repeats: true)
            
            startStopWatch = false
            startstopButton.setImage(UIImage(named: "StopButton.png"), for: UIControl.State.normal)
            lapresetButton.setImage(UIImage(named: "LapButton.png"), for: UIControl.State.normal)
            
            addLap = true
        }else {
            
            timer.invalidate()
            startStopWatch = true
            startstopButton.setImage(UIImage(named: "StartButton.png"), for: .normal)
            lapresetButton.setImage(UIImage(named: "ResetButton.png"), for: .normal)
            
            addLap = false
            
        }
        
    }
    
    
    @IBAction func lapReset(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopwatchLabel.text = "00.00.00"
    }
    
    @objc func updateStopwatch(){
        
        fractions += 1
        if fractions == 100 {
             seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        stopwatchString = "\(minutesString):\(secondsString).\(fractionsString)"
        stopwatchLabel.text = stopwatchString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell (style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = self.view.backgroundColor
        cell.textLabel?.text = "Lap"
        cell.detailTextLabel?.text = "00:00:0"
        
        return cell
        
       }


}
