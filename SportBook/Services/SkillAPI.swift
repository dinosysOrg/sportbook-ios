//
//  SkillAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let skillEndpointClosure = { (target: SkillAPI) -> Endpoint<SkillAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
}

let SkillProvider = RxMoyaProvider<SkillAPI>(endpointClosure: skillEndpointClosure)

// MARK: - Provider support

//Delcaration of Skill APIs
public enum SkillAPI  {
    case skills //Get all skills
}

extension SkillAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .skills:
            return "/skills/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .skills:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        return nil
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

