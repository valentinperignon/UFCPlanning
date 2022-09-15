//
//  PlanningManager.swift
//  
//
//  Created by Valentin Perignon on 04/09/2022.
//

import Foundation
import RealmSwift
import Security

public class PlanningManager {
    public static let shared = PlanningManager()

    public let apiFetcher: ApiFetcher
    public var user: User?

    private let realmConfiguration: Realm.Configuration

    private init() {
        apiFetcher = ApiFetcher()
        realmConfiguration = Realm.Configuration(schemaVersion: 1)
        print("[UFCPlanning] Realm location: \(realmConfiguration.fileURL?.path ?? "")")

        try? getUser()
    }

    public func getRealm() -> Realm {
        do {
            return try Realm(configuration: realmConfiguration)
        } catch {
            fatalError("Cannot get a Realm instance")
        }
    }

    // MARK: - User

    public func saveUser(login: String, password: String) async throws {
        let fetchedUser = try await apiFetcher.connect(login: login, password: password)
        let realm = getRealm()
        try? realm.write {
            realm.add(fetchedUser)
        }

        user = fetchedUser.freeze()
        try KeychainHelper.save(password: fetchedUser.token!, for: fetchedUser.id)
    }

    public func removeUser() throws {
        guard let user = user else { return }

        let userId = user.id
        let realm = getRealm()
        try? realm.write {
            realm.delete(user)
        }
        self.user = nil

        try KeychainHelper.removePassword(for: userId)
    }

    private func getUser() throws {
        let realm = getRealm()
        guard let user = realm.objects(User.self).first?.freeze() else { return }

        user.token = try KeychainHelper.getPassword(for: user.id)
        self.user = user
    }

    // MARK: - Planning

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

        let planning = try await apiFetcher.planning(for: [group], with: settings, user: user)

        let realm = getRealm()
        try? realm.write {
            realm.delete(realm.objects(Lesson.self))
            realm.add(planning)
        }
    }

    public func searchInPlanning(for text: String) -> Results<Lesson> {
        let realm = getRealm()
        let results =  realm.objects(Lesson.self).where { lesson in
            lesson.name.contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            || lesson.about.contains(text, options: [.caseInsensitive, .diacriticInsensitive])
        }
        return results
    }
}
