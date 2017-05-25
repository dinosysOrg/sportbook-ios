//
//  SkillAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let SkillProvider = MoyaProvider<Skill>()

// MARK: - Provider support

//Delcaration of Skill APIs
public enum Skill  {
    case skills //Get all skills
}

extension Skill : TargetType {
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

