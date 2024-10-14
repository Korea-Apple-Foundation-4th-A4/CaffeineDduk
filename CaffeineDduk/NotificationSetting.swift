//
//  NotificationSetting.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class NotificationSettings {
    var startTime: Date
    var endTime: Date
    var notificationCount: Int

    init(startTime: Date, endTime: Date, notificationCount: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.notificationCount = notificationCount
    }
}
