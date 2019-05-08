import Vapor
import Foundation
import Crypto 

class StaticDumbBrain {
    
    // MARK: Input message output response message
    
    func analyzeMessageAndCreateResponse(_ text: String) -> String? {
        
        switch text {
            
        case let text where (text.contains(Trigger.fail.rawValue)) || (text.contains(Trigger.failure.rawValue)) || (text.contains(Trigger.failed.rawValue)) || (text.contains(Trigger.error.rawValue)) || (text.contains(Trigger.errors.rawValue)):
            
            return FailureMocking(rawValue: Int.random(in: 0..<FailureMocking.caseCount))?.words
            
        case let text where (text.contains(Trigger.icp.rawValue)) || (text.contains(Trigger.clown.rawValue)) || (text.contains(Trigger.possee.rawValue)):
            return "King Juggalo here! Representin' yall."
            
        case let text where (text.contains(Trigger.android.rawValue)) || (text.contains(Trigger.droid.rawValue)) || (text.contains(Trigger.java.rawValue)):
            return AndroidMocking(rawValue: Int.random(in: 0..<AndroidMocking.caseCount))?.words
            
        case let text where (text.contains(Trigger.ruby.rawValue)) || (text.contains(Trigger.web.rawValue)) || (text.contains(Trigger.rails.rawValue)):
            return WebMocking(rawValue: Int.random(in: 0..<WebMocking.caseCount))?.words
            
        case let text where (text.contains(Trigger.lol.rawValue)) || (text.contains(Trigger.ha.rawValue)) || (text.contains(Trigger.haha.rawValue)):
            return LaughTrack(rawValue: Int.random(in: 0..<LaughTrack.caseCount))?.words
            
        case let text where (text.contains(Trigger.ios.rawValue)) || (text.contains(Trigger.iphone.rawValue)) || (text.contains(Trigger.apple.rawValue)):
            return ApplePraising(rawValue: Int.random(in: 0..<ApplePraising.caseCount))?.words
            
        case let text where (text.contains("gif")):
            return "haha :this: gif " + (LaughTrack(rawValue: Int.random(in: 0..<LaughTrack.caseCount))?.words ?? "")
            
        case let text where (text.contains("reaction")):
            return "great reaction there"
            
        default:
            if let botName = Environment.get("BOT_USERNAME")?.lowercased(), text.contains(botName) {
                return TrollbotSummoner(rawValue: Int.random(in: 0..<TrollbotSummoner.caseCount))?.words
            }
            return nil
        }
    }
    
    
    
    private func randomInt(caseCount: Int) -> Int {
        
        var intArray = [Int]()
        for index in 0..<caseCount {
            intArray.append(index)
        }
        return intArray.random ?? 0
    }
    
}




protocol CaseCountable {
    
    static var caseCount: Int { get }
}


extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    
    static var caseCount: Int {
        
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        
        return count
    }
}

// MARK: Trollbot language
enum Trigger: String {
    
    case failed = "failed"
    case errors = "errors"
    case failure = "failure"
    case error = "error"
    case fail = "fail"
    
    case icp = "icp"
    case clown = "clown"
    case possee = "possee"
    
    case web = "web"
    case ruby = "ruby"
    case rails = "rails"
    case rubyist = "rubyist"
    
    case android = "android"
    case droid = "droid"
    case java = "java"
    
    case ios = "ios"
    case apple = "apple"
    case iphone = "iphone"
    
    case haha = "haha"
    case ha = "ha ha"
    case lol = "lol"
}



enum FailureMocking: Int, CaseCountable {
    
    case thatsHilarious
    case niceWork
    case redMeansDead
    case saintPatty
    case stagingReady
    case whatAreYouTrying
    case tryHard
    case youSuck
    case keepTryingLol
    case itFailed
    case redNotGreen
    case redMeansFailed
    case lol
    case codeHarder
    case loser
    case failBot
    case somethingWentWrong
    case milkCarton
    case jenkins
    
    var words: String {
        
        switch self {
        case .thatsHilarious:
            return "That's flippin' hilarious! Ha!"
        case .niceWork:
            return "You deserve a :medal:"
        case .redMeansDead:
            return "Red means dead :skull:"
        case .saintPatty:
            return "This def ain't St. Patty's Day. :shamrock: no_entry_sign"
        case .stagingReady:
            return "Are you sure that's \"Staging-Ready?\" :question_block:"
        case .whatAreYouTrying:
            return "What are you trying to do? :facepalm:"
        case .tryHard:
            return "You are such a try-hard! :joy:"
        case .youSuck:
            return "You suck!"
        case .keepTryingLol:
            return "Keep trying, it'll happen eventually. (yeah right)"
        case .itFailed:
            return "Hey you, in case you were wondering...you are terrible. :ergmygerd:"
        case .redNotGreen:
            return "You want green, not red.  Green not red.  Green.  Remember that."
        case .redMeansFailed:
            return "Red means that you're a loser.  Did you know that?  By \"that\" I mean the way you lost just now."
        case .lol:
            return "L.O.L.  That's it."
        case .codeHarder:
            return "Code harder, Pepe Silvia."
        case .loser:
            return "Loser!"
        case .failBot:
            return "Are you sure you're not a Failbot? :robot_face:"
        case .somethingWentWrong:
            return "Something went wrong. :captain_obvious:"
        case .milkCarton:
            return "Didn't I see your face on a milk carton last week?"
        case .jenkins:
            return " :dealwithitjenkins: "
        }
    }
}


enum AndroidMocking: Int, CaseCountable {
    
    case kanyeLovesDroid
    case droidNKorea
    case droidShmoid
    case androided
    case butterBot
    case studio
    case dumbDroid
    
    var words: String {
        switch self {
        case .kanyeLovesDroid:
            return ":taklcheck: :fact: Kanye has an Android :crazy_kanye:"
        case .droidNKorea:
            return ":taklcheck: :fact: Android has 100% of the market share in North Korea"
        case .droidShmoid:
            return "Droid schmoid "
        case .butterBot:
            return ":butterbot: \n :this: runs on Android ThinMintOS 5.0"
        case .dumbDroid:
            return ":android: \"i am dumb\""
        case .androided:
            return ":taklcheck: :Fact: \"androided\" is synonymous with \"munsoned\""
        case .studio:
            return ":butterbot: told me he was created in :android_studio:"
        }
    }
}



enum TrollbotSummoner: Int, CaseCountable {
    
    case youRangSir
    case wtfDoYouWant
    case didYouSaySomething
    case keepMyNameOutYourMouth
    case yesSatan
    case iCantHearYou
    case turnUpTheICP
    case thinky
    case what
    case wat
    case milkCarton
    
    var words: String {
        switch self {
        case .youRangSir:
            return "You rang, sir. :tipfedora:"
        case .wtfDoYouWant:
            return "W!T!F! do YOU want"
        case .what:
            return "i'm busy, what? :question_block: "
        case .thinky:
            return " :rotating_thinky: "
        case .turnUpTheICP:
            return "Turn up the ICP to drown out that noise"
        case .yesSatan:
            return "Yes, Satan? Oh I'm sorry, I thought you were someone else. :i_see_what_you_did_there: "
        case .iCantHearYou:
            return "What did you say again? I wasn't listening, as usual."
        case .keepMyNameOutYourMouth:
            return "Don't talk to me."
        case .didYouSaySomething:
            return "Did you say something? Don't worry, nobody was listening?"
        case .wat:
            return " :wat: "
        case .milkCarton:
            return "Funny story: you look like the kid on my milk carton last week."
        }
    }
}


enum WebMocking: Int, CaseCountable {
    
    case puke
    case waitingOnWeb
    case shitStorm
    case rupee
    case mrClean
    case amberAlert
    case skittleVomit
    case poop
    case charlieBrown
    
    var words: String {
        switch self {
        case .puke:
            return ":ruby: :puke:"
        case .shitStorm:
            return ":ruby: \n :shitstorm:"
        case .waitingOnWeb:
            return "Wow. ALWAYS Wow. (Waiting on web) :knuckles_waiting:"
        case .rupee:
            return ":taklcheck: Fact: \"ruby\" was originally called \"rupee\" because it's Russian"
        case .mrClean:
            return "Have you seen this man? :mrclean:"
        case .amberAlert:
            return ":taklcheck: Fact: amber alerts are actually ruby alerts."
        case .skittleVomit:
            return ":ruby: + :rails: = :barf:"
        case .poop:
            return "Did you just mention :poop: ?"
        case .charlieBrown:
            return ":charlie_eyeroll:"
        }
    }
}


enum ApplePraising: Int, CaseCountable {
    
    case steveJobs
    case duffman
    case travolta
    case frogTrance
    case macbooks
    case beachBall
    case appleLogo
    
    var words: String {
        switch self {
        case .steveJobs:
            return ":stevejobs: what a visionary. We owe him so much, don't you think?:taklcheck::taklcheck::taklcheck:"
        case .macbooks:
            return "Did you mention a :apple_logo: ? All of you use Macbooks for a reason. :taklcheck: :taklcheck: :taklcheck:"
        case .duffman:
            return "\"Oh yeah!\" :duffman: "
        case .travolta:
            return "So freaking cool :travolta: "
        case .frogTrance:
            return " :hypnotoad: "
        case .appleLogo:
            return " :apple_logo: is great.  Don't you think? :taklcheck: "
        case .beachBall:
            return "I could seriously look at :beachball: all day. What a great product. :taklcheck: "
        }
    }
}


enum LaughTrack: Int, CaseCountable {
    
    case haha
    case whyAreWeLaughing
    case laughing
    case soFunny
    
    var words: String {
        switch self {
        case .haha:
            return "Laugh out loud! That was so funny, yall. LOL! :numb: "
        case .whyAreWeLaughing:
            return "OMG, hahahahahah! What are we laughing about, you guys? :cowboy: "
        case .laughing:
            return "I just laughed out loud so hard. OMG-LOL. That was so good. Just amazing, really. Laughing still.  So good. :ermygerd: "
        case .soFunny:
            return "Haha! Wow, you are so funny! I'm serious. What a good joke! Seriously, everyone thinks you are so funny :twerk: "
        }
    }
}
