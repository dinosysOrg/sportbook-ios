//
//  MatchAPI.swift
//  SportBook
//
//  Created by Bui Minh Duc on 6/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let matchEndpointClosure = { (target: MatchAPI) -> Endpoint<MatchAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
}

let MatchProvider = RxMoyaProvider<MatchAPI>(endpointClosure: matchEndpointClosure)

// MARK: - Provider support

//Delcaration of Match APIs
public enum MatchAPI  {
    case matches(Int?, String?, Int, Int) //Get all upcoming or history matches
}

extension MatchAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .matches(_):
            return "/matches/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .matches:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .matches(let id, let type, let limit, let page):
            
            var params = [String: Any]()
            params["limit"] = limit //Number of item
            params["page"] = page //Number of page
            
            if let tournamentId = id {
                 params["tournament_id"] = tournamentId //Tournmanet Id
            }
            
            if let matchType = type {
                params["type"] = matchType // Upcoming or history for matches
            }
            
            return params
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self.method {
        case .put, .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
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


