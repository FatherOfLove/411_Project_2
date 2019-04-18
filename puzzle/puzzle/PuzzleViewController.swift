//
//  PuzzleViewController.swift
//  puzzle
//

import UIKit
import AVFoundation

enum Direction {
    case Horizontal
    case Vertical
}

class Cell {
    var enable = false;
    var number = 0;
    var string = "";
}

class PuzzleViewController: UIViewController, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    let screenWidth = UIScreen.main.bounds.width;
    var textfields: Array<UITextField> = Array();
    var cells : Array< Array<Cell> > = Array();
    var data: JSON?
    var mode: Direction = .Horizontal
    var tip: UILabel = UILabel()
    var timer: UILabel = UILabel()
    var step: UILabel = UILabel()
    var scoreLable: UILabel = UILabel()
    var button: UIButton = UIButton()
    var homeButton: UIButton = UIButton()
    let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    var verticalTip = [JSON]()
    var horizontalTip = [JSON]()
    var currentTimeUsed = 0;
    var currentStep = 0;
    var totalBlank = 0;
    var currentTextField: UITextField? = nil
    var level = 1;
    var player : AVAudioPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initData();
        initViews();
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    deinit {
//        codeTimer.cancel();
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        codeTimer.cancel()
        player?.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Settings.shared.musicOn {
            player = Tools.playSound();
        }
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))

            codeTimer.setEventHandler(handler: {
                self.currentTimeUsed += 1;
                DispatchQueue.main.async {
                    self.timer.text = "Time: \(String(self.currentTimeUsed))";
                }
            })
            codeTimer.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var topSafeArea: CGFloat
        var bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top // 20 //44
            bottomSafeArea = view.safeAreaInsets.bottom // 0 //34
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        // safe area values are now available to use
    }
    
    func initData() {
        data = Tools.parseJSON(filename: "level\(level)");
        verticalTip = data!["clues"]["down"].arrayValue;
        horizontalTip = data!["clues"]["across"].arrayValue;
    }
    
    func initViews() {
        let perCellWidht = Double(screenWidth / 15);
        
        guard data != nil else {
            return;
        }
        
        let gridNumber = data!["gridNums"].arrayValue ;
        let gridChar = data!["grid"].arrayValue;
        
        let toolBarY = isNotchScreen ? 44 : 20;
        
        let toolBar = UIView.init(frame: CGRect.init(x: 0, y: toolBarY, width: Int(screenWidth), height: 55));
        
        tip = UILabel.init(frame: CGRect.init(x: 10, y: 500, width: 300, height: 50));
        tip.textColor = UIColor.gray;
        
        if (Settings.shared.timerOn) {
            timer = UILabel.init(frame: CGRect.init(x: 100, y: 2, width: 80, height: 50))
            timer.textColor = UIColor.black
            toolBar.addSubview(timer);
        }
        
        if (Settings.shared.moveCounterOn) {
            step = UILabel.init(frame: CGRect.init(x: 180 , y: 2, width: 80, height: 50))
            step.textColor = UIColor.black
            step.text = "Step: 0"
            toolBar.addSubview(step);
        }
        
        scoreLable = UILabel.init(frame: CGRect.init(x: screenWidth - 120, y: 2, width: 100, height: 50));
        scoreLable.textColor = UIColor.brown
        toolBar.addSubview(scoreLable);
        
        button = UIButton.init(frame: CGRect.init(x: screenWidth - 50, y: 13, width: 40, height: 30))
        button.setTitleColor(.magenta, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        
        homeButton = UIButton.init(frame: CGRect.init(x: 20, y: 12, width: 60, height: 30))
        homeButton.setTitle("Home", for: .normal)
        
        homeButton.setTitleColor(.gray, for: .normal)
        homeButton.addTarget(self, action: #selector(back), for: .touchUpInside)

        toolBar.addSubview(homeButton)
        toolBar.addSubview(button);
        toolBar.addBottomBorderWithColor(color: .gray, width: 1.0)
        
        let buttonTitle = mode == .Horizontal ? "H" : "V";
        button.setTitle(buttonTitle, for: .normal);
        button.addTarget(self, action: #selector(changeMode), for: .touchUpInside);

        self.view.addSubview(toolBar)
//        self.view.addSubview(tip)
        
        for i in 0..<15{
            var cellArray = [Cell]();
            for j in 0..<15{
                let cell = Cell();
                let textfield = UITextField(frame: CGRect(x: Double(j) * perCellWidht , y: Double(i) * perCellWidht + Double(toolBarY) + Double(80), width: perCellWidht, height: perCellWidht));
                textfield.backgroundColor = UIColor.white
                textfield.layer.borderColor = UIColor.gray.cgColor
                textfield.layer.borderWidth = 1
                textfield.textAlignment = .center
                textfield.returnKeyType = .next
                textfield.delegate = self;
                textfield.keyboardType = .asciiCapable;
                textfield.autocorrectionType = .no;
                textfield.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
                textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

                textfield.tag = i * 15 + j;
                if (gridNumber[i * 15 + j].int != 0) {
                    let lable = UILabel(frame: CGRect(x: 2, y: 2, width: 15, height: 15))
                    lable.font = UIFont.systemFont(ofSize: 8)
                    lable.text = String(gridNumber[i * 15 + j].int!)
                    textfield.addSubview(lable);
                    cell.number = gridNumber[i * 15 + j].int!;
                }
                if (gridChar[i * 15 + j].string == ".") {
                    textfield.backgroundColor = UIColor.black;
                    textfield.isEnabled = false;
                    cell.enable = false;
                } else {
                    totalBlank += 1;
                    cell.string = gridChar[i * 15 + j].string!
                    cell.enable = true;
                }
                
                self.view.addSubview(textfield)
                textfields.append(textfield);
                cellArray.append(cell);
            }
            cells.append(cellArray);
        }
        scoreLable.text = "0 / \(totalBlank)"

    }
    
    @objc func changeMode() {
        mode = (mode == .Vertical) ? .Horizontal :.Vertical
        let title = mode == .Vertical ? "V" : "H"
        button.setTitle(title, for:.normal)
        if ((self.currentTextField) != nil) {
            textFieldDidBeginEditing(self.currentTextField!)

        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentStep += 1;
        step.text = "Step: \(currentStep)"

        for textfield in textfields {
            if (textfield.isEnabled) {
                textfield.backgroundColor = UIColor.white;
            }
        }

        let i = Int(textField.tag / 15);
        let j = textField.tag % 15;
        var currentNum = 0;

        if (Settings.shared.highlighOn) {
            textField.backgroundColor = UIColor.yellow;
        }
        if (mode == .Horizontal) {
            let cellArray = cells[i];
            for k in (0..<j).reversed() {
                let cell = cellArray[k];
                if cell.enable {
                    if (Settings.shared.highlighOn) {
                        textfields[i * 15 + k].backgroundColor = UIColor.orange
                    }
                } else {
                    currentNum = cellArray[k+1].number
                    break
                }
            }
            for k in j+1..<15 {
                let cell = cellArray[k];
                if cell.enable {
                    if (Settings.shared.highlighOn) {
                        textfields[i * 15 + k].backgroundColor = UIColor.orange
                    }
                    
                } else {
                    break
                }
            }
            if (currentNum == 0) {
                currentNum = cellArray[0].number

            }
            
            for string in horizontalTip {
                if (string.string!.starts(with: String(currentNum))) {
                    tip.text = string.string!;
                    let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                    numberToolbar.barStyle = .default
                    let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50));
                    label.text = string.string!;
                    let button = UIBarButtonItem.init(customView: label);
                    numberToolbar.items = [button];
                    numberToolbar.sizeToFit()
                    textField.inputAccessoryView = numberToolbar
                    break;
                }
            }
            
        } else {
            for k in (0..<i).reversed() {
                let cell = cells[k][j];
                if cell.enable {
                    if (Settings.shared.highlighOn) {
                        textfields[k * 15 + j].backgroundColor = UIColor.orange;
                    }
                } else {
                    currentNum = cells[(k + 1)][j].number
                    break
                }
            }
            for k in i+1..<15 {
                let cell = cells[k][j];
                if cell.enable {
                    if (Settings.shared.highlighOn) {
                        textfields[k * 15 + j].backgroundColor = UIColor.orange;
                    }                } else {
                    break
                }
            }
            if (currentNum == 0) {
                currentNum = cells[0][j].number
            }
            
            for string in verticalTip {
                if (string.string!.starts(with: String(currentNum))) {
                    tip.text = string.string!;
                    let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                    numberToolbar.barStyle = .default
                    let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50));
                    label.text = string.string!;
                    let button = UIBarButtonItem.init(customView: label);
                    numberToolbar.items = [button];
                    numberToolbar.sizeToFit()
                    textField.inputAccessoryView = numberToolbar
                    break;
                }
            }
        }
        var rightCount = 0;
        for iX in 0..<15 {
            for iY in 0..<15 {
                let cell = cells[iX][iY]
                if (cell.enable) {
                    let textfield = textfields[iX * 15 + iY]
                    if (textfield.text?.uppercased() == cell.string.uppercased()) {
                        textfield.textColor = .black
                        rightCount += 1;
                    } else {
                        if textfield.text != "" {
                            textfield.textColor = .red
                        } else {
                            
                        }
                    }
                } else {
                    
                }
            }
        }
        if (rightCount == totalBlank) {
             win()
        }
        scoreLable.text = "\(rightCount) / \(totalBlank)"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = nil;
        textField.text = textField.text?.uppercased()
        textField.backgroundColor = UIColor.white;
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let i = Int(textField.tag / 15);
        let j = textField.tag % 15;
        if (mode == .Horizontal) {
            if (i * 15 + j + 1 < 224) {
                let txf = textfields[i * 15 + j + 1];
                if (txf.isEnabled) {
                    txf.becomeFirstResponder();
                } else {
                }
            } else {
                
            }
        } else {
            if ((i+1) * 15 + j < 224) {
                let txf = textfields[(i+1) * 15 + j]
                if (txf.isEnabled) {
                    txf.becomeFirstResponder();
                }
            }
        }
        textField.resignFirstResponder();
        return true;
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 1 {
            return false;
        }
        string.uppercased();
        return true;
    }
    
    
    
    func win() {
        Tools.playWinSound()
        let alertController = UIAlertController(title: "Congratulate", message: "go on to next level", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            let vc = PuzzleViewController();
            vc.level = self.level + 1;
            self.navigationController?.pushViewController(vc, animated: true);
            self.navigationController?.viewControllers.remove(at:1);
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reload() {
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tip.frame = CGRect.init(x: 10, y: keyboardRectangle.origin.y - 100, width: 300, height: 50);
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func myTargetFunction(textField: UITextField) {
        if (currentTextField == textField) {
            changeMode()
        }
        currentTextField = textField;
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if (Settings.shared.smartStepOn) {
                textFieldShouldReturn(textField);
            }
        }
    }
}
