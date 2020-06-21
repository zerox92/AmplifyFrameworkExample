//
//  SignIn.swift
//  amplify-cognito-ios-sample
//
//  Created by Anjum, Zeeshan on 15/06/2020.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation
import UIKit
import AWSPluginsCore
import Amplify
import AWSMobileClient

typealias CognitoCompletionBlock = (Error?) -> Void

class Cognito {
    class func signUpUser(with username: String, password: String, userAttributes: [String: String]?, _ completionHandler: @escaping CognitoCompletionBlock) {
        var authAttributes : [AuthUserAttribute]? = []
        
        if let userAttributesDictionary = userAttributes {
            if let email = userAttributesDictionary["email"] {
                authAttributes?.append(AuthUserAttribute.init(.email, value: email))
            }
            
            if let name = userAttributesDictionary["name"] {
                authAttributes?.append(AuthUserAttribute.init(.name, value: name))
            }
            
            if let phone = userAttributesDictionary["phone_number"] {
                authAttributes?.append(AuthUserAttribute.init(.phoneNumber, value: phone))
            }
        }
        
        _ = Amplify.Auth.signUp(username: username, password: password, options: AuthSignUpRequest.Options.init(userAttributes: authAttributes, pluginOptions: nil)) { (result) in
            switch (result) {
            case .success(let authSignUpResult):
                print("SignUpResult: \(authSignUpResult)")
                completionHandler (nil)
            case .failure(let authError):
                print("SignUp Error: \(authError)")
                completionHandler (authError)
            }
        }
    }
    
    class func confirmUser(username: String, confirmationCode: String, _ completionHandler: @escaping CognitoCompletionBlock) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode, listener: { (result) in
            switch result {
            case .success(let authSignUpResult):
                print("SignUpResult: \(authSignUpResult)")
                print("Successfully confirmed user")
                completionHandler(nil)
            case .failure(let authError):
                print("Error confirming user")
                completionHandler(authError)
            }
        })
    }
    
    class func resendConfirmationCode(username: String, _ completionHandler: @escaping CognitoCompletionBlock) {
        _ = Amplify.Auth.resendSignUpCode(for: username, listener: { (result) in
            switch result {
            case .success(let authDeliveryDetails):
                print("AuthDeliveryResult: \(authDeliveryDetails)")
                print("Resent confirmtion code")
                completionHandler(nil)
            case .failure(let authError):
                print("Failed sending confirmation code again")
                completionHandler(authError)
            }
        })
    }
    
    class func signIn(with username: String, password: String, _ completionHandler: @escaping CognitoCompletionBlock) {
        _ = Amplify.Auth.signIn(username: username, password: password, options: nil, listener: { (result) in
            switch result {
            case .success(let authSignInResult):
                if authSignInResult.isSignedIn {
                    print("User is signed in")
                    completionHandler(nil)
                } else {
                    //check authSignInResult.nextStep
                    print("Next Step required")
                    print("Check: \(authSignInResult.nextStep)")
                }
            case .failure(let authError):
                print("Sign in failed: \(authError.localizedDescription)")
                completionHandler(authError)
            }
        })
        
    }
    
    class func showBuiltInUi(navigationController: UINavigationController) {
        AWSMobileClient.default().showSignIn(navigationController: navigationController, { (signInState, error) in
            if let signInState = signInState {
                print("Sign in flow completed: \(signInState)")
            } else if let error = error {
                print("error logging in: \(error.localizedDescription)")
            }
        })
    }
    
    class func showHostedUI(navigationController: UINavigationController, completionHandler: @escaping CognitoCompletionBlock) {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: navigationController.view.window!, listener: { (result) in
            switch result {
            case .success(let signInReult):
                print("User Sign in:")
                print("\(signInReult)")
                completionHandler(nil)
            case .failure(let authError):
                print(authError.localizedDescription)
                completionHandler(authError)
            }
        })
    }
    
    class func signOut(_ completionHandler: @escaping CognitoCompletionBlock) {
        _ = Amplify.Auth.signOut(listener: { (result) in
            switch result {
            case .success():
                completionHandler(nil)
            case .failure(let authError):
                print("Error: \(authError.debugDescription)")
                completionHandler(authError)
            }
        })
    }
    
    class func getUsername(_ completion: ((_ username: String?) -> Void)?) {
        if let user = Amplify.Auth.getCurrentUser() {
            completion?(user.username)
        } else {
            completion?(nil)
        }
    }
    
    class func getTokens() {
        _ = Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()

                // Get user sub or identity id
                if let identityProvider = session as? AuthCognitoIdentityProvider {
                    let usersub = try identityProvider.getUserSub().get()
                    let identityId = try identityProvider.getIdentityId().get()
                    print("User sub - \(usersub) and identity id \(identityId)")
                }

                // Get aws credentials
                if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                    let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                    print("Access key - \(credentials.accessKey) ")
                }

                // Get cognito user pool token
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    print("Id token - \(tokens.idToken) ")
                    print("Access token - \(tokens.accessToken) ")
                    print("Refresh token - \(tokens.refreshToken) ")
                }

            } catch {
                print("Fetch auth session failed with error - \(error)")
            }
        }
    }
}


//MARK: Helpers
extension Cognito {
    class func initialize(_ completionHandler: @escaping CognitoCompletionBlock) {
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
                completionHandler(nil)
            } else {
                completionHandler(error)
            }
        }
    }
}
