//
//  AppDelegate.swift
//  MapsKit
//
//  Created by Alex Larin on 21.02.2021.
//

import UIKit
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Настройка ключа
        GMSServices.provideAPIKey("AIzaSyCMMBq9ah8XZVxza4xCtiAF-pNymihz8T0")
        
        // запрос разрешения на показ уведомлений:
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeIntervalNotificatioTrigger())
        }
       // получение статуса настроек уведомлений:
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Разрешение есть")
            case .denied:
                print("Разрешения нет")
            case .notDetermined:
                print("Неясно, есть или нет разрешение")
            case .provisional:
                break
            case .ephemeral:
                break
            @unknown default:
                break
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // метод создания контента уведомления:
    func makeNotificationContent() -> UNNotificationContent {
        // Внешний вид уведомления
        let content = UNMutableNotificationContent()
        // Заголовок
        content.title = "MapsKIT"
        // Подзаголовок
        content.subtitle = "напоминает Вам"
        // Основное сообщение
        content.body = "Приложение свернуто"
        // Цифра в бейдже на иконке
        content.badge = 1
        return content
    }
    // метод создания объекта уведомления (в данном случае UNNotificationTrigger - устанавливает количество секунд, которое пройдёт от отправки запроса до показа уведомления)
    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            // Количество секунд до показа уведомления
            timeInterval: 20,
            // Надо ли повторять
            repeats: false
        )
    }
    // Итоговый метод получает контент уведомления, событие его показа, создаёт запрос и добавляет его в центр уведомлений
    func sendNotificatioRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
        // Создаём запрос на показ уведомления
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        // Добавляем запрос в центр уведомлений
        center.add(request) { error in
            // Если не получилось добавить запрос,
            // показываем ошибку, которая при этом возникла
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

