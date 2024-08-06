//
//  AthletesDiaryAppApp.swift
//  AthletesDiaryApp
//
//  Created by sherzod on 10/05/24.
//

import SwiftUI
import UserNotifications

@main
struct AthletesDiaryAppApp: App {
    init() {
        requestNotificationAuthorization()
        scheduleDailyNotification(at: 6, minute: 0)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}

func scheduleDailyNotification(at hour: Int, minute: Int) {
    let content = UNMutableNotificationContent()
    content.title = "Good Morning!"
    content.body = "Don't forget to add breakfast meal."
    content.sound = UNNotificationSound.default

    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "daily-6am-notification", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled for 6 AM.")
        }
    }
}
