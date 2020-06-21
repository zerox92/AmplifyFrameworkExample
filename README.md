# AmplifyFrameworkExample
Amplify framework auth category example

### Usage:
1. Clone the repo.
2. Add your Amplify config files (`awsconfiguration.json`, `amplifyconfiguration.json`, `amplifytools.xcconfig`) to the root of the project. Example of the config files provided at the end.
3. Run `pod install`.
4. Open `AmplifyFramework.xcworkspace`.
5. Build & run.

Please note that myapp:// is setup by default for the Hosted UI callback URL in the Info.plist file. Edit this value as necessary.

#### amplifytools.xcconfig

~~~
push=false
modelgen=false
profile=default
envName=amplify
~~~

#### amplifyconfiguration.json
~~~
{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify/cli",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "",
                            "Region": ""
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "",
                        "AppClientId": "",
                        "AppClientSecret": "",
                        "Region": ""
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "OAuth": {
                            "WebDomain": "",
                            "AppClientId": "",
                            "AppClientSecret": "",
                            "SignInRedirectURI": "myapp://",
                            "SignOutRedirectURI": "myapp://",
                            "Scopes": ["openid", "email"]
                        }
                    }
                }
            }
        }
    }
}

~~~

#### awsconfiguration.json
~~~
{
    "UserAgent": "aws-amplify/cli",
    "Version": "0.1.0",
    "IdentityManager": {
        "Default": {}
    },
    "CredentialsProvider": {
        "CognitoIdentity": {
            "Default": {
                "PoolId": "",
                "Region": ""
            }
        }
    },
    "CognitoUserPool": {
        "Default": {
            "PoolId": "",
            "AppClientId": "",
            "AppClientSecret": "",
            "Region": ""
        }
    },
    "Auth": {
        "Default": {
            "authenticationFlowType": ""
        }
    }
}

~~~

![APP UI](./README_IMAGES/UI.png?raw=true "UI")
