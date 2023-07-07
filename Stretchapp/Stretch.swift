//
//  Stretch.swift
//  
//
//  Created by Alexander Kvamme on 18/04/2021.
//

import Foundation

struct Stretch: Hashable, Codable {

    // MARK: - Properties

    let uuid: UUID
    let title: String
    let duration: Duration
    var durationInSeconds: Int {
        let oneSideDuration = duration.inSeconds()
        return isTwoSided ? oneSideDuration*2 : oneSideDuration
    }
    let isTwoSided: Bool

    // MARK: - Initializers

    init(title: String, length: Duration, uuid: UUID = UUID(), isTwoSided: Bool = false) {
        self.isTwoSided = isTwoSided
        self.title = title
        self.duration = length
        self.uuid = uuid
    }

    static let dummy = Stretch(title: "This is a dummy stretch", length: Duration(amount: 30, type: .seconds))
    static let completion = Stretch(title: "Nearly there!", length: Duration(amount: 30, type: .seconds))
    static let defaultLength = Duration(amount: 90, type: .seconds)
    static let debugLength = Duration(amount: 10, type: .seconds)
    static let favourites = [
        Stretch(title: "Pigeon pose", length: Self.defaultLength, isTwoSided: true),
        Stretch(title: "Hands folded behind back", length: defaultLength),
        Stretch(title: "Low squat", length: Self.defaultLength),
        Stretch(title: "Spinal twist", length: Self.defaultLength, isTwoSided: true),
        Stretch(title: "Back bend", length: Self.defaultLength),
        Stretch(title: "Forward fold", length: Self.defaultLength),
        Stretch(title: "Quad bends", length: Self.defaultLength),
        Stretch(title: "Happy baby", length: Duration(amount: Self.defaultLength.amount, type: .seconds)),
        Stretch(title: "Back rollers", length: Duration(amount: Self.defaultLength.amount, type: .seconds)),
        Stretch.completion
    ]
    static let forDebugging = [
        Stretch(title: "Hands folded behind back", length: Self.debugLength),
        Stretch(title: "Low squat", length: Self.debugLength),
        Stretch(title: "Spinal twist", length: Self.debugLength, isTwoSided: true),
        Stretch(title: "Back bend", length: Self.debugLength),
        Stretch(title: "Forward fold", length: Self.debugLength),
        Stretch(title: "Pigeon pose", length: Self.debugLength, isTwoSided: true),
        Stretch(title: "Backflips", length: Self.debugLength),
        Stretch(title: "Swaggers", length: Self.debugLength),
        Stretch(title: "Jump masters", length: Self.debugLength),
        Stretch.completion
    ]

    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case duration
        case isTwoSided
    }
}
