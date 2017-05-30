//
//  TournamentAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let TournamentProvider = MoyaProvider<TournamentAPI>()

// MARK: - Provider support

//Declaration of Tournament APIs
public enum TournamentAPI  {
    case tournaments //Get all tournaments
    case tournament(String) //Get a tournament by Id
    case myTournaments //Get my tournaments
    case signupTournament(String, [Int], String, [Int]?) //Sign up for a tournament by Id
}

extension TournamentAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .tournaments:
            return "/tournaments/"
        case .tournament(let id):
            return "/tournament/\(id.urlEscaped)"
        case .myTournaments:
            return "/tournaments/my-tournaments"
        case .signupTournament(let id, _, _, _):
            return "/tournaments/\(id.urlEscaped)/teams"
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
        case .signupTournament(_, let venueRanking, let teamName, let members):
           return [
            "name" : teamName, //Team Name
            "venue_ranking " : venueRanking, //Venue ranking for team
            "user_ids" : members ?? [] //Arrays user for creating team
            ]
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
