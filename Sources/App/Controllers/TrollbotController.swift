import Vapor
import Crypto
import Foundation
import Logging

/// Controls basic CRUD operations on `Todo`s.
final class TrollbotController: RouteCollection {

    func boot(router: Router) throws {
        print("THIS IS RUNNING")
        let group = router.grouped("trollbot")
        group.post(SlackRequest.self, at: "/", use: send)
    }
    
    
    
    func send(_ request: Request, _ data: SlackRequest) throws -> HTTPStatus {
 
        let logger = try request.make(Logger.self)
        logger.verbose(request.http.body.debugDescription)
        logger.verbose(request.http.headers.debugDescription)
        
        if let secret = request.http.headers.firstValue(name: HTTPHeaderName("X-Slack-Signature")),
            let timestamp = request.http.headers.firstValue(name: HTTPHeaderName("X-Slack-Request-Timestamp")),
            let rawData = request.http.body.data,
            let requestString = String(data: rawData, encoding: .utf8) {
            
            let finalString = "v0:\(timestamp):\(requestString)"
            let hmac = try HMAC.SHA256.authenticate(finalString, key: Environment.get("SIGNING_SECRET")!)
            let hash = hmac.map { String(format: "%02x", $0) }.joined()
            
            if "v0=\(hash)" == secret {
                reply(data.event)
                return .ok
            }
        }
        
        return .unauthorized
    }
    
    
    
    private func reply(_ event: SlackEvent) {
        
        DispatchQueue.global().async {
            self.checkForReply(event)
        }
    }
    
    
    
    private func checkForReply(_ event: SlackEvent) {
        
        guard let input = event.text, (event.username?.lowercased() != Environment.get("BOT_USERNAME")?.lowercased()) && (event.bot_id != Environment.get("BOT_ID")), let trollResponse = StaticDumbBrain().analyzeMessageAndCreateResponse(input.lowercased()) else { return }
   
        
        let channel = event.channel ?? ""
        
        let response = """
        { "text": "\(trollResponse)", "channel": "\(channel)", "as_user": "false" }
        """
        self.sendMessage(data: response)
    }
   
    
    
    private func sendMessage(data: String) {
        
        let token = "Bearer \(Environment.get("OAUTH_BOT_TOKEN")!)"
       
        guard let slackURL = URL(string: "https://slack.com/api/chat.postMessage") else { return }

        var urlRequest = URLRequest(url: slackURL)
        urlRequest.allHTTPHeaderFields = [
            "Content-type": "application/json",
            "Authorization": token
        ]
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data.data(using: .utf8)
        
        let configuration = URLSessionConfiguration.default
        URLSession(configuration: configuration).dataTask(with: urlRequest) { _, _, _ in
            print("Msg sent")
            }.resume()
    }
}



