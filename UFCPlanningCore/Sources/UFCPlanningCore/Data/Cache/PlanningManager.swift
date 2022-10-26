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
        let realmDirectory = Constants.sharedGroupURL!.appendingPathComponent("plannings", isDirectory: true)
        try? FileManager.default.createDirectory(atPath: realmDirectory.path, withIntermediateDirectories: true)

        apiFetcher = ApiFetcher()
        realmConfiguration = Realm.Configuration(
            fileURL: realmDirectory.appendingPathComponent("plannings.realm"),
            schemaVersion: 1
        )
        print("[UFCPlanning] Realm location: \(realmConfiguration.fileURL?.path ?? "")")

        try? getUser()
    }

    public func getRealm() -> Realm {
        do {
            return try Realm(configuration: realmConfiguration)
        } catch {
            fatalError("Cannot get a Realm instance: \(error.localizedDescription)")
        }
    }

    // MARK: - User

    public func saveUser(login: String, password: String) async throws {
        let fetchedUser = try await apiFetcher.connect(login: login, password: password)
        let token = fetchedUser.token!

        let realm = getRealm()
        try? realm.write {
            realm.add(fetchedUser)
        }

        user = fetchedUser.freeze()
        user?.token = token
        try KeychainHelper.save(password: token, for: fetchedUser.id)
    }

    public func removeUser() throws {
        guard let user = user?.thaw() else { return }

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

    // MARK: - Groups

    public func save(group: Group) {
        let realm = getRealm()
        guard realm.object(ofType: Group.self, forPrimaryKey: group.id) == nil else { return }

        try? realm.write {
            realm.add(group)
        }
    }

    public func toggleVisibility(of group: Group) {
        let realm = getRealm()
        try? realm.write {
            group.isVisible = !group.isVisible
        }
    }

    public func delete(group: Group) {
        let realm = getRealm()
        try? realm.write {
            realm.delete(group)
        }
    }

    // MARK: - Planning

    public func planning() async throws {
        let groups = loadGroups()
        let settings = loadSettings()

        var planning = [Lesson]()
        if !groups.isEmpty {
            planning = try await apiFetcher.planning(for: groups, with: settings, user: user)
        }

        let realm = getRealm()
        try? realm.write {
            realm.delete(realm.objects(Lesson.self))
            realm.add(planning)
        }
    }

    public func fetchNextLessons() async throws -> [Lesson] {
        let groups = loadGroups()
        let settings = PlanningSettings(
            numberOfDays: 4,
            mode: .separatedByDate,
            withColors: true,
            withSports: true,
            withExtra: true
        )

        return try await apiFetcher.planning(for: groups, with: settings)
    }

    public func searchInPlanning(for text: String) -> Results<Lesson> {
        let realm = getRealm()
        let results =  realm.objects(Lesson.self).where { lesson in
            lesson.name.contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            || lesson.about.contains(text, options: [.caseInsensitive, .diacriticInsensitive])
        }
        return results
    }

    // MARK: - Private methods

    private func loadGroups() -> [Group] {
        let realm = getRealm()
        let groups = realm.objects(Group.self).where { $0.isVisible == true }
        return Array(groups)
    }

    private func loadSettings() -> PlanningSettings {
        let visibility = VisibilityDays(rawValue: UserDefaults.standard.integer(forKey: "daysNumber")) ?? .defaultValue
        let campusSport = UserDefaults.standard.bool(forKey: "campusSport")
        return PlanningSettings(
            numberOfDays: visibility.rawValue,
            mode: .separatedByDate,
            withColors: true,
            withSports: campusSport,
            withExtra: true
        )
    }
}
