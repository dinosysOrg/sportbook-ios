//
//  TeamAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import SwiftyJSON
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
    case timeBlock(Int) //Get time blocks and venue ranking for team
}

extension TeamAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .timeSlot(_, let id):
            return "/teams/\(id)/time_slots/"
        case .teams(let id, _, _):
            return "/teams/\(id)/"
        case .timeBlock(let id):
            return "/teams/\(id)/time_blocks/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .timeSlot(_), .timeBlock(_):
            return .get
            
        case .teams(_):
            return .put
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .timeSlot(let _,let id):
            return [
                "type" : "available", //Type
                "id " : id, //Team Id
            ]
        case .teams(let id, let rankVenue, let preferredTimeBlocks):
            let params = [
                "team_id" : id, //Team Id
                "venue_ranking" : rankVenue, //Venue ranking for team
                "preferred_time_blocks" : preferredTimeBlocks //Preferred time block for team
            ] as [String : Any]
            
            let jsonObject = JSON(params)
            print(jsonObject)
            
            return params
        case .timeBlock(let id):
            return [
                "id " : id, //Team Id
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

