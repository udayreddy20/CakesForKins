//
//  SuccessVC.swift
//  cakeApp


import UIKit

class SuccessVC: UIViewController {

  // @IBOutlet weak var vwSuccess: AnimationView!
    
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //   self.vwSuccess.contentMode = .scaleAspectFit
   // self.vwSuccess.loopMode = .playOnce
   //     self.vwSuccess.animationSpeed = 1.5
    //    self.vwSuccess.play()
        
        self.TimerChange()
        // Do any additional setup after loading the view.
    }
    
    func TimerChange(){
        
        var timeLeft = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("timer fired!")
            timeLeft += 1
            if timeLeft == 5 {
                timer.invalidate()
                UIApplication.shared.setTab()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
}
