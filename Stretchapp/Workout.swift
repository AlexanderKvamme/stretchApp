//
//  Workout.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 05/04/2021.
//

import Foundation

struct Workout: Hashable, Codable {
    let name: String
    var duration: Duration {
        let workoutInSeconds = stretches.reduce(0) { return $0 + $1.durationInSeconds }
        let celebrationLength = stretches.last?.duration.inSeconds() ?? 0
        let minutes = (workoutInSeconds-celebrationLength)/60
        return Duration(amount: minutes, type: .minutes)
    }
    let stretches: [Stretch]

    static let dummy = Workout(name: "Test workout", stretches: Stretch.forDebugging)
    static let gabos = Workout(name: "Office worker stretches", stretches: Stretch.favourites)
    static let dummies = [
        Workout(name: "Forward folding", stretches: Stretch.forDebugging),
        Workout(name: "Gabos Schnip", stretches: Stretch.favourites),
        Workout(name: "Programmer stretches", stretches: Stretch.forDebugging)]

    enum CodingKeys: String, CodingKey {
       case name
       case stretches
    }
}
