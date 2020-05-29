//
//  TimeZone.swift
//  ios-clock
//
//  Created by user169339 on 5/28/20.
//

import Foundation

struct Timezone: Codable {
    let uuid: UUID
    let identifier: String
    var name: String
    init(name: String, identifier: String) {
        (self.name, self.identifier, self.uuid) = (name, identifier, UUID())
    }
}
