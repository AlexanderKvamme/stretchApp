//
//  DAO.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 04/04/2021.
//

import UIKit

protocol ObjectSavable {
    func setMyObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}


enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}


extension UserDefaults: ObjectSavable {
    func setMyObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}




class DAO: NSObject {

    // MARK: - Properties

    static let allWorkoutsKey = "all-workouts"

    // MARK: - Methods

    static func getWorkouts() -> [Workout] {
        let ud = UserDefaults()

        do {
            let workouts = try ud.getObject(forKey: allWorkoutsKey, castTo: [Workout].self)
            return workouts
        } catch {
            print(error)
        }

        return [Workout]()
    }

    static func saveWorkout(_ workout: Workout) {
        var existingWorkouts = getWorkouts()
        existingWorkouts.append(workout)

        do {
            try  UserDefaults.standard.setMyObject(existingWorkouts, forKey: allWorkoutsKey)
        } catch {
            print(error)
        }
    }
}


