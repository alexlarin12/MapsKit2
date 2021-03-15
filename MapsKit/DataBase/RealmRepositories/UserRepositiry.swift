//
//  UserRepositiry.swift
//  MapsKit
//
//  Created by Alex Larin on 04.03.2021.
//

import Foundation
import RealmSwift

class UserRepository {
    var realmUsers = [User]()
    // метод сохранения пользователя в Realm:
    func saveUserData(login: String, password: String, avatar: String){
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            var userToAdd = [User]()
            realm.beginWrite()
            //realm.deleteAll()
            let realmUser = User()
                realmUser.login = login
                realmUser.password = password
                realmUser.avatar = avatar
                userToAdd.append(realmUser)
            realm.add(userToAdd, update: .modified)
            try realm.commitWrite()
            print(try! Realm().configuration.fileURL!)
        } catch {
            print(error)
        }
    }
    
    // метод получения пользователя из Realm:
    func getUserData() -> Array<User>{
        do {
            let realm = try Realm()
            let userFromRealm = realm.objects(User.self)
            self.realmUsers = Array(userFromRealm)
        } catch {
            print(error)
        }
        return realmUsers
    }
    
    func searchUser(login: String) throws -> Array<User> {
          do {
              let realm = try Realm()
              let userRealm = realm.objects(User.self).filter("login CONTAINS[c] %@", login)
            self.realmUsers = Array(userRealm)
          } catch {
              throw error
          }
        return realmUsers
    }
    func compareUserData(login: String, password: String) throws -> Array<User> {
          do {
              let realm = try Realm()
              let userRealm = realm.objects(User.self).filter("login = '\(login)' AND password = '\(password)'")
            self.realmUsers = Array(userRealm)
          } catch {
              throw error
          }
        return realmUsers
    }
    
}
