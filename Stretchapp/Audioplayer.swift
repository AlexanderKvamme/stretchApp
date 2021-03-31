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
        let path = Bundle.main.path(forResource: sound.rawValue, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("could not load sound effect")
        }
    }
}
