//
//  LocalDatabase.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/23.
//

import Foundation
import SQLite

class LocalDatabase: NSObject {
    static let shared = LocalDatabase()
    private var db: Connection?

    override init() {
        super.init()
        initializeDatabase()
    }

    private func initializeDatabase() {
        do {
            let fileManager = FileManager.default
            let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let databasePath = docsDir.appendingPathComponent("db.sqlite3").path

            if !fileManager.fileExists(atPath: databasePath) {
                db = try Connection(databasePath)
                createTables()
            } else {
                db = try Connection(databasePath)
            }
        } catch {
            print("Unable to open database: \(error)")
        }
    }

    private func createTables() {
        do {
            let photos = Table("photos")
            let id = Expression<Int64>("id")
            let name = Expression<String?>("name")
            let path = Expression<String>("path")

            try db?.run(photos.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(path)
            })
        } catch {
            print("Failed to create table: \(error)")
        }
    }
}


extension LocalDatabase {
    
    /// 新增照片
    func insertPhoto(name: String, imagePath: String) {
        let photos = Table("photos")
        let nameColumn = Expression<String?>("name")
        let pathColumn = Expression<String>("path")
        
        do {
            try db?.run(photos.insert(nameColumn <- name, pathColumn <- imagePath))
            print("Photo inserted successfully.")
        } catch {
            print("Insertion failed: \(error)")
        }
    }

    /// 搜尋所有照片
    func fetchPhotos() -> [(name: String, path: String)] {
        guard let db = db else {
            print("Database connection is closed.")
            return []
        }
        var results: [(name: String, path: String)] = []
        let photos = Table("photos")
        let nameColumn = Expression<String?>("name")
        let pathColumn = Expression<String>("path")

        do {
            for photo in try db.prepare(photos) {
                let name = photo[nameColumn] ?? "Unnamed"
                let path = photo[pathColumn]
                results.append((name: name, path: path))
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        return results
    }
    
    func fetchRandomPhotos(limit: Int) -> [(name: String, path: String)] {
        guard let db = db else {
            print("Database connection is closed.")
            return []
        }
        var results: [(name: String, path: String)] = []
        let photos = Table("photos")
        let nameColumn = Expression<String?>("name")
        let pathColumn = Expression<String>("path")

        do {
            for photo in try db.prepare(photos.order(Expression<Int64>.random()).limit(limit)) {
                let name = photo[nameColumn] ?? "Unnamed"
                let path = photo[pathColumn]
                results.append((name: name, path: path))
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        return results
    }

}
