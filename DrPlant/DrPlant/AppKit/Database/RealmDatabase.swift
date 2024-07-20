//
//  RealmDatabase.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import Foundation
import RealmSwift

final class RealmDatabase {
    private static let fileName = "DrPlant.realm"
    
    private let config: Realm.Configuration
    
    static let schemaVersion = UInt64(2)
    
    init() {
        var fileURL = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        fileURL?.appendPathComponent(RealmDatabase.fileName)

        config = Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: RealmDatabase.schemaVersion
        )

        Realm.Configuration.defaultConfiguration = config
    }
    
    public func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        guard let realm = realmInstance() else {
            return nil
        }
        realm.refresh()

        if let predicate {
            return realm.objects(type).filter(predicate)
        } else {
            return realm.objects(type)
        }
    }

    public func add<T: Object>(_ objects: [T]) {
        guard let realm = realmInstance() else {
            return
        }
        realm.refresh()

        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
        } else {
            try? realm.write {
                realm.add(objects, update: .modified)
            }
        }
    }
    
    public func delete<T: Object>(_ type: T.Type, forPrimaryKey key: String) {
        guard let realm = realmInstance() else {
            return
        }
        realm.refresh()

        guard let object = realm.object(ofType: type, forPrimaryKey: key) else {
            return
        }

        try? realm.write {
            realm.delete(object)
        }
    }
    
    private func realmInstance() -> Realm? {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            return realm
        }
        return realm
    }
}
