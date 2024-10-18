//
//  User.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import Foundation
import SwiftData

@Model
final class User {
    var name: String
    var startTime: Date
    var endTime: Date
    var notificationCount: Int

    init(name: String, startTime: Date, endTime: Date, notificationCount: Int) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.notificationCount = notificationCount
    }
}
