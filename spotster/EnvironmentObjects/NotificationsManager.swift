//
//  NotificationsManager.swift
//  spotster
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

let NEW_NOTIFICATIONS = "<NEW_NOTIFICATIONS>"

@MainActor
class NotificationManager: ObservableObject {
    @Published var notifications : [UserNotification] = []
    @Published var newNotifications: Int = 0
    
    private var documentDirectory: URL
    private var enabled: Bool
    
    init() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first {
            self.documentDirectory = documentDirectory
            self.enabled = true
        } else {
            self.documentDirectory = URL(filePath: "busted.bust")
            self.enabled = false
        }
        
        self.readJSON()
        self.getCachedNewNotifications()
    }
    
    func getCachedNewNotifications() {
        let value = AppStorage.init(wrappedValue: 0, NEW_NOTIFICATIONS)
        self.newNotifications = value.wrappedValue
    }
    
    func setCachedNewNotifications() {
        var value = AppStorage.init(wrappedValue: 0, NEW_NOTIFICATIONS)
        value.wrappedValue = self.newNotifications
        value.update()
    }
    
    func getNotifications(token: String) async {
        if !self.isEnabled() {
            return
        }
        
        // backend caps the amount received here to 50
        let notificationResult = await spotster.getNotifications(token: token)
        
        switch notificationResult {
        case .success(var incomingNotifications):
            // dedupe the incoming from existing
            for notification in self.notifications {
                incomingNotifications.removeAll(where: {$0.id == notification.id})
            }
            
            // add pending viewed
            self.newNotifications += incomingNotifications.count
            self.setCachedNewNotifications()
            
            self.notifications.append(contentsOf: incomingNotifications)
            self.notifications = self.notifications.sorted {$0.created > $1.created }
            
            if self.notifications.count > 50 {
                self.notifications = Array(self.notifications[0...50])
            }
            
            // write them to file to persist them through launches
            self.writeJSON()
            
            // confirming the notifications have been received
            let _ = await spotster.confirmNotifications(token: token)
        case .failure(_):
            return
        }
    }
    
    /// Writes the current notifications to the file.
    private func writeJSON() {
        if self.isEnabled() {
            let url = self.getCommonURL()
            try? JSONEncoder().encode(notifications).write(to: url, options: .atomic)
        }
    }
    
    /// Reads the json and if any error is thrown, write a new empty document to the file.
    private func readJSON() {
        if self.isEnabled() {
            let url = self.getCommonURL()
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let decoder =  JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.notifications = try decoder.decode([UserNotification].self, from: data)
            } catch {
                let url = self.getCommonURL()
                try? JSONEncoder().encode([UserNotification]()).write(to: url, options: .atomic)
            }
        }
    }
    
    
    private func isEnabled() -> Bool {
        return self.enabled
    }
    
    private func getCommonURL() -> URL {
            return documentDirectory
                .appendingPathComponent("notifications")
                .appendingPathExtension("json")
    }
}
