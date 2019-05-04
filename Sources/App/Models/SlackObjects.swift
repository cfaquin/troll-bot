import Vapor 

struct SlackRequest: Content {
    let token: String?
    let team_id: String?
    let api_app_id: String?
    let event: SlackEvent?
    let type: String?
    let authed_users: [String]?
    let event_id: String?
    let event_time: UInt64?
    let challenge: String?
}

struct SlackEvent: Content {
    let type: String
    let user: String?
    let text: String?
    let channel: String?
}

