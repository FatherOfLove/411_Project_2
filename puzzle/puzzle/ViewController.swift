//
//  ViewController.swift
//  puzzle
//
//

import UIKit

class ViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData();
        initViews();
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.title = "Home"
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    func initData() {
    }
    
    func initViews() {
        let button = UIButton(frame: CGRect(x: 100, y: 350, width: 140, height: 50))
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(gotoGame), for: .touchUpInside);
        button.layer.cornerRadius = 25
        button.center = CGPoint(x: screenWidth / 2.0 , y: 350);
        self.view.addSubview(button)
        
        let setting = UIButton(frame: CGRect(x: 100, y: 420, width: 140, height: 50))
        setting.setTitle("Settings", for: .normal)
        setting.setTitleColor(UIColor.white, for: .normal)
        setting.backgroundColor = UIColor.black
        setting.layer.cornerRadius = 25
        setting.addTarget(self, action: #selector(gotoSettings), for: .touchUpInside);
        setting.center = CGPoint(x: screenWidth / 2.0 , y: 420);

        self.view.addSubview(setting)
        
        let title = UILabel(frame: CGRect(x: 80, y: 100, width: 300, height:80));
        title.text = "Puzzle Word"
        title.font = UIFont.systemFont(ofSize: 40);
        title.textColor = .black
        title.textAlignment = .center
        
        title.center = CGPoint(x: screenWidth / 2.0 , y: 100);

        self.view.addSubview(title)
    }

    @objc func gotoGame() {
        self.navigationController?.pushViewController(PuzzleViewController(), animated: true)
    }
    
    @objc func gotoSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}

