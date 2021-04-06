//
//  Workout.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 05/04/2021.
//

import Foundation

struct Workout: Hashable, Codable {
    let name: String
    let duration: Duration
    let stretches: [Stretch]

    static let dummy = Workout(name: "Test workout", duration: Duration(amount: 45, type: .seconds), stretches: Stretch.forDebugging)
    static let gabos = Workout(name: "Gabo's daily", duration: Duration(amount: 90, type: .seconds), stretches: Stretch.favourites)
    static let dummies = [
        Workout(name: "Forward folding", duration: Duration(amount: 45, type: .seconds), stretches: Stretch.forDebugging),
        Workout(name: "Gabos Schnip", duration: Duration(amount: 99, type: .minutes), stretches: Stretch.favourites),
        Workout(name: "Programmer stretches", duration: Duration(amount: 10, type: .minutes), stretches: Stretch.forDebugging)]

    enum CodingKeys: String, CodingKey {
       case name
       case duration
       case stretches
    }
}
