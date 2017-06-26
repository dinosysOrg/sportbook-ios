//
//  TeamAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let teamEndpointClosure = { (target: TeamAPI) -> Endpoint<TeamAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
}

let TeamProvider = RxMoyaProvider<TeamAPI>(endpointClosure: teamEndpointClosure)

// MARK: - Provider support

//Delcaration of Team APIs
public enum TeamAPI  {
    case timeSlot(String, Int) //Get time slots for team
    case teams(Int, [Int], [String:Any]) //Updates time slot and venue ranking for team
}

extension TeamAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .timeSlot(_, let id):
            return "/teams/\(id)/time_slots/"
        case .teams(let id, _, _):
            return "/teams/\(id)/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .timeSlot(_,_):
            return .get
            
        case .teams(_, _, _):
            return .put
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .timeSlot(let type,let id):
            return [
                "type" : type, //Type
                "id " : id, //Team Id
            ]
        case .teams(let id, let rankVenue, let preferredTimeBlocks):
            return [
                "team_id" : id, //Team Id
                "venue_ranking" : rankVenue, //Venue ranking for team
                "preferred_time_blocks" : preferredTimeBlocks //Preferred time block for team
            ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .request
    }
    
    public var validate: Bool {
        return false
    }
    
    public var sampleData: Data {
        return Data()
    }
}

