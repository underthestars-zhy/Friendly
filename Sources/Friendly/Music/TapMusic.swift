//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/4/14.
//

import SwiftUI
import AVFoundation

class TapMusic {
    static var audioPlayer: AVPlayer?

    static func playSounds() {
        guard let url = Bundle.module.url(forResource: "tap.mp3", withExtension: nil) else { return }
        let item = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: item)
        audioPlayer?.isMuted = false
        audioPlayer?.play()
    }
}
