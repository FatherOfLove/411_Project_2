//
//  Settings.swift
//  puzzle
//

import UIKit

class Settings: NSObject {
    var musicOn = true;
    var timerOn = true;
    var smartStepOn = true;
    var moveCounterOn = true;
    var highlighOn = true;
    static let shared = Settings()
    
    private override init() {
        super.init()
    }

}
