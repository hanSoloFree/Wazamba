import AVFoundation

var player: AVAudioPlayer?

func playSound() {
    guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        player.numberOfLoops = -1
        
        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
}
