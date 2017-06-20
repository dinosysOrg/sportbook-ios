//
//  DeviceAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let DeviceProvider = MoyaProvider<DeviceAPI>()

// MARK: - Provider support

//Delcaration of Device APIs
public enum DeviceAPI  {
    case create(Int, String, Int) //Store device token
}

extension DeviceAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .create(_,_,_):
            return "/devices/create"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .create(_,_,_):
            return .post
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .create(let id,let token, let platform):
            return [
                "type" : id, //User Id
                "id " : token, //Device Token
                "platform" : platform //Platform ‘0 - iOS’ || ‘1 - Android’
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

