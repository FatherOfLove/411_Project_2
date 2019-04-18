//
//  SettingsViewController.swift
//  puzzle
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Settings"
        UIBarButtonItem.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    func initViews() {
        let musicOnLabel = UILabel.init(frame: CGRect.init(x: 30, y: 100, width: 80, height: 30));
        musicOnLabel.text = "Music :"
        self.view.addSubview(musicOnLabel)
        
        let switchMusic = UISwitch.init(frame: CGRect.init(x: 200, y: 100, width: 100, height: 30));
        switchMusic.addTarget(self, action: #selector(musicToggle), for: .valueChanged)
        self.view.addSubview(switchMusic)
        switchMusic.setOn(Settings.shared.musicOn, animated: true)
        
        
        let timeOnLabel = UILabel.init(frame: CGRect.init(x: 30, y: 150, width: 80, height: 30));
        timeOnLabel.text = "Time :"
        self.view.addSubview(timeOnLabel)
        
        let switchTime = UISwitch.init(frame: CGRect.init(x: 200, y: 150, width: 130, height: 30));
        switchTime.addTarget(self, action: #selector(timeToggle), for: .valueChanged)
        self.view.addSubview(switchTime)
        
        switchTime.setOn(Settings.shared.timerOn, animated: true)
        
        
        let stepOnLabel = UILabel.init(frame: CGRect.init(x: 30, y: 200, width: 80, height: 30));
        stepOnLabel.text = "Step :"
        self.view.addSubview(stepOnLabel)
        
        let switchStep = UISwitch.init(frame: CGRect.init(x: 200, y: 200, width: 100, height: 30));
        switchStep.addTarget(self, action: #selector(stepToggle), for: .valueChanged)
        self.view.addSubview(switchStep)
        
        switchStep.setOn(Settings.shared.moveCounterOn, animated: true)
        
        
        let autoNextLabel = UILabel.init(frame: CGRect.init(x: 30, y: 250, width: 130, height: 30));
        autoNextLabel.text = "AutoNext :"
        self.view.addSubview(autoNextLabel)
        
        let switchAutoNext = UISwitch.init(frame: CGRect.init(x: 200, y: 250, width: 100, height: 30));
        switchAutoNext.addTarget(self, action: #selector(autoNextToggle), for: .valueChanged)
        self.view.addSubview(switchAutoNext);
        
        switchAutoNext.setOn(Settings.shared.smartStepOn, animated: true)
        
        let highlightLabel = UILabel.init(frame: CGRect.init(x: 30, y: 300, width: 130, height: 30));
        highlightLabel.text = "Hightlight :"
        self.view.addSubview(highlightLabel)
        
        let switchHighlight = UISwitch.init(frame: CGRect.init(x: 200, y: 300, width: 100, height: 30));
        switchHighlight.addTarget(self, action: #selector(highlightLabelToggle), for: .valueChanged)
        self.view.addSubview(switchHighlight)
        
        switchHighlight.setOn(Settings.shared.highlighOn, animated: true)

    }
    
    @objc func musicToggle(sender: UISwitch) {
        print(sender.isOn);
        Settings.shared.musicOn = sender.isOn
    }
    
    @objc func timeToggle(sender: UISwitch) {
        print(sender.isOn);
        Settings.shared.timerOn = sender.isOn
    }
    
    @objc func stepToggle(sender: UISwitch) {
        print(sender.isOn);
        Settings.shared.moveCounterOn = sender.isOn
    }

    @objc func autoNextToggle(sender: UISwitch) {
        print(sender.isOn);
        Settings.shared.smartStepOn = sender.isOn
    }
    
    @objc func highlightLabelToggle(sender: UISwitch) {
        print(sender.isOn)
        Settings.shared.highlighOn = sender.isOn
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
