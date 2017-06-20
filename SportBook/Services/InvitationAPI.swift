//
//  InvitationAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let InvitationProvider = MoyaProvider<InvitationAPI>()

// MARK: - Provider support

//Delcaration of Invitation APIs
public enum InvitationAPI  {
    case create(String, Int, Int) //Create invitation
    case accept(Int) //Accept invitation
    case reject(Int) //Reject invitation
    case detail(Int) //Get invitation detail
}

extension InvitationAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .create(_,_,_):
            return "/invitations/create/"
        case .accept(let id):
            return "/invitations/\(id)/accept/"
        case .reject(let id):
            return "/invitations/\(id)/reject/"
        case .detail(let id):
            return "/invitations/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .create(_,_,_):
            return .post
        case .accept(_), .reject(_):
            return .put
        case .detail(_):
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .create(let time,let venueId, let matchId):
            return [
                "time" : time, //Time
                "venue_id " : venueId, //Venue Id
                "match_id" : matchId //Match Id
            ]
        case .accept(let id):
            return [
                "invitation_id" : id //Invitation Id
            ]
        case .reject(let id):
            return [
                "invitation_id" : id //Invitation Id
            ]
        case .detail(let id):
            return [
                "invitation_id" : id //Invitation Id
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

