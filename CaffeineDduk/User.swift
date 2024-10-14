//
//  User.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftData

@Model
final class User {
    var name: String

    init(name: String) {
        self.name = name
    }
}
