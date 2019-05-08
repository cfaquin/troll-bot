import Vapor
import Foundation
import Crypto

enum ColorType: String {
    case good
    case warning
    case danger
}

enum EventType: String {
    case message
    case reaction_added
}

struct SlackRequest: Content {
    let token: String
    let team_id: String
    let api_app_id: String
    let event: SlackEvent
    let type: String
    let authed_users: [String]
    let event_id: String
    let event_time: UInt64
}

struct SlackEvent: Content {
    let type: String?
    let user: String?
    let text: String?
    let channel: String?
    let username: String?
    let bot_id: String?
    let attachments: [SlackAttachment]?
}


struct SlackAttachment: Content {
    let text: String?
    let ts: UInt64?
    let title: String?
    let title_link: String?
    let pretext: String?
    let color: String?
}

