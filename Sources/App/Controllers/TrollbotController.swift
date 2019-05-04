import Vapor
import Crypto
import Foundation

/// Controls basic CRUD operations on `Todo`s.
final class TrollbotController: RouteCollection {

    func boot(router: Router) throws {
        print("THIS IS RUNNING")
        let group = router.grouped("trollbot")
        group.post(SlackRequest.self, at: "/", use: send)
    }
    
    
    
    func send(_ request: Request, _ data: SlackRequest) throws -> HTTPResponse {
        
        if data.type == "url_verification", let challenge = data.challenge {
            
            var response = HTTPResponse(status: .ok, body: challenge)
            response.headers.add(name: .contentType, value:"text/plain")
            return response
        }
        
        if let secrect = request.http.headers.firstValue(name: HTTPHeaderName("X-Slack-Signature")),
            let timestamp = request.http.headers.firstValue(name: HTTPHeaderName("X-Slack-Request-Timestamp")),
            let rawData = request.http.body.data,
            let requestString = String(data: rawData, encoding: .utf8) {
            
            let finalString = "v0:\(timestamp):\(requestString)"
            let hmac = try HMAC.SHA256.authenticate(finalString, key: Environment.get("signingSecret")!)
            let hash = hmac.map { String(format: "%02x", $0) }.joined()
            
            if "v0=\(hash)" == secrect, data.api_app_id != Environment.get("apiAppID") {
                reply(data.event)
                return HTTPResponse(status: .ok)
            }
        }
        
        return HTTPResponse(status: .unauthorized)
    }
    
    
    
    private func reply(_ event: SlackEvent?) {
        
        guard let event = event else { return }
        
        DispatchQueue.global().async {
            self.checkForReply(event)
        }
    }
    
    
    
    private func checkForReply(_ event: SlackEvent?) {
        
        guard let event = event, let input = event.text, let trollResponse = StaticDumbBrain().analyzeMessageAndCreateResponse(input) else { return }
   
        let channel = event.channel ?? ""
        let response = """
            { "text": "\(trollResponse)", "channel": "\(channel)" }
            """
        self.sendMessage(data: response)
    }
   
    
    
    private func sendMessage(data: String) {
        
        let token = "Bearer \(Environment.get("OAUTHBotToken")!)"
       
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


