//
//  BannerImageViewTimerHandler.swift
//  BannerImageSlider
//
//  Created by Bhavesh Patel on 07/04/21.
//

import Foundation

class BannerImageViewTimerHandler: NSObject {
    var timer: Timer?
    var timerComlpetion: ((Any?)->Void)?
    var index: Int?
    
    override init() {
        super.init()
        startOrResumeTimer()
    }

    @objc func timerAction(_ timer: Timer) {
        timerComlpetion?(index)
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }

    func startOrResumeTimer(with index: Int? = nil) {
        self.index = index
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
}
