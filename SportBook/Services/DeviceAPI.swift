//
//  DeviceAPI.swift
//  SportBook
//
//  Created by DucBM on 6/12/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya

let deviceEndpointClosure = { (target: DeviceAPI) -> Endpoint<DeviceAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
}

let DeviceProvider = RxMoyaProvider<DeviceAPI>(endpointClosure: deviceEndpointClosure)

// MARK: - Provider support

//Delcaration of Device APIs
public enum DeviceAPI  {
    case create(String, String, String?) //Store device token
    case delete(String) //Delete device token
}

extension DeviceAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    public var path: String {
        switch self {
        case .create(_):
            return "/devices/create"
        case .delete(_):
            return "/devices/delete"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .create(_):
            return .post
        case .delete(_):
            return .put
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .create(let udid, let token, let uid):
            var params = [ "udid" : udid, //Device Id
                "token " : token, //Device Token
                "platform" : 0 //Platform ‘0 - iOS’ || ‘1 - Android’
            ] as [String : Any]
            
            if let userId = uid {
                params["user_id"] = userId //User Id
            }
            return params
        case .delete(let udid):
            return [
                "udid" : udid, //Device Id
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

