//
//  PlanningManager.swift
//  
//
//  Created by Valentin Perignon on 04/09/2022.
//

import Foundation
import RealmSwift

public class PlanningManager {
    public let apiFetcher: ApiFetcher
    
    private let realmConfiguration: Realm.Configuration
    
    public init() {
        apiFetcher = ApiFetcher()
        realmConfiguration = Realm.Configuration(schemaVersion: 1)
        print("[UFCPlanning] Realm location: \(realmConfiguration.fileURL?.path ?? "")")
    }
    
    public func getRealm() -> Realm {
        do {
            return try Realm(configuration: realmConfiguration)
        } catch {
            fatalError("Cannot get a Realm instance")
        }
    }
    
    public func planning() async throws {
        // TODO: Get selected groups and settings
        let group = Group(id: 15862, name: "Alt", type: .final)
        let settings = PlanningSettings(
            numberOfDays: 60,
            mode: .separatedByDate,
            withColors: true,
            withSports: true,
            withExtra: true
        )
        
        let planning = try await apiFetcher.planning(for: [group], with: settings)
        
        let realm = getRealm()
        try? realm.write {
            realm.delete(realm.objects(Day.self))
            realm.add(planning)
        }
    }
}
