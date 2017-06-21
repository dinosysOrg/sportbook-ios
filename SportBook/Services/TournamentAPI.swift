//
//  TournamentAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let tournamentEndpointClosure = { (target: TournamentAPI) -> Endpoint<TournamentAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
}


let TournamentProvider = RxMoyaProvider<TournamentAPI>(endpointClosure: tournamentEndpointClosure)

// MARK: - Provider support

//Declaration of Tournament APIs
public enum TournamentAPI  {
    case tournaments //Get all tournaments
    case tournament(Int) //Get a tournament by Id
    case myTournaments //Get my tournaments
    case upcomingTournaments //Get all upcoming tournaments
    case upcomingMatches //Get all upcoming matches
    case signupTournament(Int, String, Int, String, Int, String?, String?, [Int]?) //Sign up for a tournament by Id
}

extension TournamentAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .tournaments:
            return "/tournaments/"
        case .tournament(let id):
            return "/tournaments/\(id)"
        case .myTournaments:
            return "/tournaments/my-tournaments"
        case .signupTournament(let id, _, _, _, _, _, _, _):
            return "/tournaments/\(id)/teams"
        case .upcomingTournaments:
            return "/tournaments/my-tournaments/upcoming-tournaments/"
        case .upcomingMatches:
            return "/tournaments/my-tournaments/upcoming-matches/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signupTournament(_):
            return .post
        default:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .signupTournament(let id, let name,  let phone, let address, let skillId, let club, let birthday, let users):
            let params =  [
                "tournament_id" : id, //Tournament Id
                "name" : name, //Team Name
                "phone_number" : phone, //Phone Number
                "address" : address, //Address
                "skill_id": skillId, //Skill Id
                "club" : club ?? "", //Club name
                "brithday" : birthday ?? "", //Birthday
                "user_ids" : users ?? [] //Members Id
            ] as [String : Any]
            
            print(params)
            return params
        default:
            return nil
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
