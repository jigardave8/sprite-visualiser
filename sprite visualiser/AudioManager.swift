//
//  AudioManager.swift
//  sprite visualiser
//
//  Created by Jigar on 17/06/24.
//

import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    let visualizerScene = VisualizerScene(size: CGSize(width: 300, height: 300))
    private var trackIndex = 0
    private let tracks = ["music1", "music2", "music3"] // Add more tracks as needed
    
    func setupAudio() {
        loadTrack()
    }
    
    func loadTrack() {
        guard let url = Bundle.main.url(forResource: tracks[trackIndex], withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.delegate = self
        } catch {
            print("Error setting up audio player: \(error)")
        }
    }
    
    func play() {
        audioPlayer?.play()
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
    }
    
    func previousTrack() {
        trackIndex = (trackIndex - 1 + tracks.count) % tracks.count
        loadTrack()
        play()
    }
    
    func nextTrack() {
        trackIndex = (trackIndex + 1) % tracks.count
        loadTrack()
        play()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateAudioLevel()
        }
    }
    
    func updateAudioLevel() {
        audioPlayer?.updateMeters()
        let averagePower = audioPlayer?.averagePower(forChannel: 0) ?? 0
        let level = self.scaledPower(averagePower)
        visualizerScene.updateVisualizer(with: level)
    }
    
    func scaledPower(_ power: Float) -> CGFloat {
        return CGFloat((power + 160) / 160)
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextTrack()
    }
}
