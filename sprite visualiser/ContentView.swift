//
//  ContentView.swift
//  sprite visualiser
//
//  Created by Jigar on 17/06/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    
    var body: some View {
        ZStack {
            // Visualizer background
            VisualizerView(scene: audioManager.visualizerScene)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay content
            VStack {
                Spacer()
                // Album artwork
                Image("album_artwork")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                
                // Track information
                VStack {
                    Text("Track Title")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text("Artist Name")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                
                // Seek bar
                Slider(value: $currentTime, in: 0...duration, onEditingChanged: { _ in
                    audioManager.seek(to: currentTime)
                })
                .padding()
                .accentColor(.white)
                
                // Time labels
                HStack {
                    Text(formatTime(currentTime))
                        .foregroundColor(.white)
                    Spacer()
                    Text(formatTime(duration))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                // Playback controls
                HStack {
                    Button(action: {
                        audioManager.previousTrack()
                    }) {
                        Image(systemName: "backward.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                    Button(action: {
                        if isPlaying {
                            audioManager.pause()
                        } else {
                            audioManager.play()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                    Button(action: {
                        audioManager.nextTrack()
                    }) {
                        Image(systemName: "forward.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
        .onAppear {
            audioManager.setupAudio()
            duration = audioManager.audioPlayer?.duration ?? 0
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                self.currentTime = audioManager.audioPlayer?.currentTime ?? 0
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
