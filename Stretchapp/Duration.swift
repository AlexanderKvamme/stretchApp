//
//  Duration.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 05/04/2021.
//

import Foundation

enum DurationType: String, Hashable, Codable {
    case minutes = "m"
    case seconds = "s"

    enum CodingKeys: String, CodingKey {
       case minutes
       case seconds
    }
}


struct Duration: Hashable, Codable {
    let amount: Int
    let type: DurationType

    enum CodingKeys: String, CodingKey {
       case amount
       case type
    }

    func inSeconds() -> Int {
        return type == DurationType.seconds ? amount : amount*60
    }
}
