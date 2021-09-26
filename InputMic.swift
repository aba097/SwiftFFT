//
//  InputMic.swift
//
//  Created by aba097 on 2021/09/26.
//

import Foundation
import AVFoundation

class InputMic {

    let audioEngine = AVAudioEngine()
    
    //fft
    var mFFTHelper: FFT!
    var l_fftData: UnsafeMutablePointer<Float32>!
    
    init(inMaxFramesPerSlice:Int){
        l_fftData = UnsafeMutablePointer.allocate(capacity: 2048)
        bzero(l_fftData, size_t(2048 * MemoryLayout<Float32>.size))
        
        mFFTHelper = FFT(maxFramesPerSlice: inMaxFramesPerSlice)
    }

    deinit {
        stopRecord()
        l_fftData.deallocate()
    }
    
    
    func startRecord() {
        // Audio Sessionを録音モードに変更
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        try! AVAudioSession.sharedInstance().setActive(true)

        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 4096, format: nil, block: {
            (buffer, time) in

            //録音データをFFTする
            let bfr = UnsafePointer(buffer.floatChannelData!.pointee)
            self.mFFTHelper.computeFFT(bfr, outFFTData: self.l_fftData)
    
            //これがFFTしたデータ
            for i in 0 ..< 2048 {
                print(self.l_fftData[i])
            }
            
        })
        // 録音の開始
        audioEngine.prepare()
        if !audioEngine.isRunning {
            try! audioEngine.start()
        }

    }

    func stopRecord() {
        // 録音停止
        if audioEngine.isRunning {
            audioEngine.stop()
            // Tapを削除（登録したままにすると次に Installした時点でエラーになる
            //mixer.removeTap(onBus: 0)
            audioEngine.inputNode.removeTap(onBus: 0)

            // Audio sessionを停止
            try! AVAudioSession.sharedInstance().setActive(false)
        }
    }

}
