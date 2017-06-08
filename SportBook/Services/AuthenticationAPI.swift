//
//  AuthenticationAPI.swift
//  SportBook
//
//  Created by DucBM on 5/23/17.
//  Copyright © 2017 dinosys. All rights reserved.
//

import Foundation
import Moya


let authEndpointClosure = { (target: AuthenticationAPI) -> Endpoint<AuthenticationAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    switch target {
    case .signOut:
        return defaultEndpoint.adding(newHTTPHeaderFields: AuthManager.sharedInstance.toDictionary())
    default:
        return defaultEndpoint
    }
}

let AuthenticationProvider = RxMoyaProvider<AuthenticationAPI>(endpointClosure: authEndpointClosure)

// MARK: - Provider support

//Delcaration of Authentication APIs
public enum AuthenticationAPI  {
    case signInWithEmail(String, String) //Signin with email and password
    case signInWithFacebook(String)
    case signUp(String, String) //Sign up with email and password
    case signOut //Sign up with email and password
    case forgotPassword(String) //Reset password
}

extension AuthenticationAPI : TargetType {
    public var baseURL: URL { return URL(string: SportBookAPI.URL)! }
    
    //Path for each API
    public var path: String {
        switch self {
        case .signUp(_, _):
            return "/auth"
        case .signInWithEmail(_, _):
            return "/auth/sign_in"
        case .signInWithFacebook(_):
            return "/auth/sign_in_with_facebook"
        case .signOut:
            return "/auth/sign_out"
        case .forgotPassword(_):
            return "/auth/password"
        }
    }
    
    //HTTP Method for each API
    public var method: Moya.Method {
        switch self {
        case .signOut:
            return .delete
        default:
            return .post
        }
    }
    
    //Parameters for each API
    public var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let password):
            return ["email": email,
                    "password": password]
        case .signInWithEmail(let email, let password):
            return ["email": email,
                    "password": password]
        case .signInWithFacebook(let accessToken):
            return ["access_token" : accessToken]
        case .forgotPassword(let email):
            return ["email" : email]
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
