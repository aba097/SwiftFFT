//
//  ViewController.swift
//
//  Created by aba097 on 2021/09/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let inputmic = InputMic(inMaxFramesPerSlice: 4096)
        
        //録音する
        inputmic.startRecord()
        
        //録音終了する
        //inputmic.stopRecord()
        
        //Info.plistにPrivacy - Microphone Usage Description を追加する
        
    }


}

