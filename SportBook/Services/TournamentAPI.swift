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
    case tournament(String) //Get a tournament by Id
    case myTournaments //Get my tournaments
    case upcomingTournaments //Get all upcoming tournaments
    case upcomingMatches //Get all upcoming matches
    case signupTournament(String, [Int], [Int]?, Int) //Sign up for a tournament by Id
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
        case .signupTournament(let teamName, let venueRanking, let members, let id):
            return [
                "name" : teamName, //Team Name
                "venue_ranking " : venueRanking, //Venue ranking for team
                "user_ids" : members ?? [], //Arrays user for creating team
                "tournament_id" : id //Tournament Id
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
