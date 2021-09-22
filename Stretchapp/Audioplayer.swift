//
//  Audioplayer.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 22/03/2021.
//

import AVFoundation

class Audioplayer: NSObject {

    // MARK: - Properties

    static var player: AVAudioPlayer?

    // MARK: - Methods

    enum Sound: String {
        case newStretch = "SpaceBall_Rise1.caf"
        case congratulations = "Toy_Up&Down1.caf"
    }

    static func play(_ sound: Sound) {
        if (AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint) {
            return
        }

        let path = Bundle.main.path(forResource: sound.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("could not load sound effect")
        }
    }
}
