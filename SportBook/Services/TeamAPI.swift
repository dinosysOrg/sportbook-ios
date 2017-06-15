//
//  TeamAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let TeamProvider = MoyaProvider<TeamAPI>()

// MARK: - Provider support

//Delcaration of Skill APIs
public enum TeamAPI  {
    case timeSlot(String, Int) //Get time slots for team
}

extension TeamAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .timeSlot(_, let id):
            return "/teams/\(id)/time_slots/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .timeSlot(_,_):
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .timeSlot(let type,let id):
            return [
                "type" : type, //Type
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

