//
//  SoundPlayer.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 02/01/2021.
//

import Foundation
import AVFoundation


class SoundPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    
    var soundPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    
    override init() {
        super.init()
    }
    
    func playSound(soundName: String) {
        
        guard let audioFile: URL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFile)
            
            guard let player = soundPlayer else { return }
                player.delegate = self
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                print(error)
                }
            
            if UserDefaults.standard.bool(forKey: "increaseSound") {
                player.volume = 0
            }
            
            player.play()
            player.setVolume(0.1,fadeDuration: 5.0)
            isPlaying = true
            
        } catch let error {
            print("Error \(error)")
        }
    }
    
    func stopSound() {
        soundPlayer?.stop()
        soundPlayer?.currentTime = 0
        isPlaying = false
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
  }

