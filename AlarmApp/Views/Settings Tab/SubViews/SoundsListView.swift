//
//  SoundListView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 05/01/2021.
//

import SwiftUI

struct SoundsListView: View {
    
    // MARK:- PROPERTIES
    
    @ObservedObject var soundPlayer = SoundPlayer()
    @State private var rowPlaying: [Bool] = [Bool](repeating: false, count: 4)
    @State private var lastRowPlayingIndex: Int = -1
    
    @AppStorage(SettingsKeys.selectedSound.description) var soundNumber: Int = 0
    
    @State var number: Int = 0
  
    // MARK: - BODY
    
    var body: some View {
        
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.radialCenter, Color.radialEdge]), center: .center, startRadius: 10, endRadius: 500)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        List {
            ForEach(0..<SettingsVM.shared.sounds.count, id:\.self) { index in
                Button(action: {
                    
                    soundNumber = index // WILL SAVE SELECTED SOUND TO USERDEFAULTS
                    SettingsVM.shared.selectedSound = index
                    
                    if (soundPlayer.isPlaying == true && lastRowPlayingIndex != index) {
                        if lastRowPlayingIndex != -1 {
                            rowPlaying[lastRowPlayingIndex].toggle()
                        }
                        soundPlayer.stopSound()
                        playSound(soundName: SettingsVM.shared.sounds[index])
                    } else if (soundPlayer.isPlaying == true ) {
                        soundPlayer.stopSound()
                        rowPlaying[lastRowPlayingIndex].toggle()
                        return
                    }
                    playSound(soundName: SettingsVM.shared.sounds[index])
                    rowPlaying[index].toggle()
                    lastRowPlayingIndex = index
                }) {
                    HStack {
                        Text(SettingsVM.shared.sounds[index])
                        Spacer()
                        if soundPlayer.isPlaying == true {
                            Image(systemName: rowPlaying[index] ? "stop" : "play")
                        } else {
                            Image(systemName: "play")
                        } //: ELSE
                    } //: HSTACK IN BUTTON
                } //: BUTTON
                .listRowBackground( lastRowPlayingIndex == index ? Color.accentDark : Color.radialEdge)
            } //: FOREACH
        } //: LIST
     }
    }
    func playSound(soundName: String) {
        soundPlayer.playSound(soundName: soundName)
    }
}
