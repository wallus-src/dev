import AVFoundation
import SpriteKit

/// Plays generated chiptune WAVs from the bundle. Small pool of players so
/// rapid SFX (coins, stomps) can overlap; music is one looping player.
final class SoundPlayer {
    static let shared = SoundPlayer()

    private var players: [String: [AVAudioPlayer]] = [:]
    private var musicPlayer: AVAudioPlayer?
    var muted = false

    private func url(_ name: String) -> URL? {
        Bundle.main.url(forResource: name, withExtension: "wav")
    }

    func play(_ name: String, volume: Float = 1.0) {
        guard !muted, let url = url(name) else { return }
        var pool = players[name] ?? []
        if let idle = pool.first(where: { !$0.isPlaying }) {
            idle.volume = volume
            idle.currentTime = 0
            idle.play()
            players[name] = pool
            return
        }
        if let p = try? AVAudioPlayer(contentsOf: url) {
            p.prepareToPlay()
            p.volume = volume
            p.play()
            pool.append(p)
            players[name] = pool
        }
    }

    func playMusic(_ name: String) {
        guard let url = url(name) else { return }
        if musicPlayer == nil, let p = try? AVAudioPlayer(contentsOf: url) {
            p.numberOfLoops = -1
            p.volume = 0.55
            p.prepareToPlay()
            musicPlayer = p
        }
        musicPlayer?.play()
    }

    func stopMusic() {
        musicPlayer?.stop()
    }
}
