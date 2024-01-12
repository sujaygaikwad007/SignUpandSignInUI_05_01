////
////  ViewController.swift
////  Travel_App
////
////  Created by Siddhesh on 06/01/24.
////
//
//import UIKit
//import FBSDKLoginKit
//import AuthenticationServices
//import GoogleSignIn
//class ViewController: UIViewController {
//
//
//    @IBOutlet weak var googleBtn: UIButton!
//
//    @IBOutlet weak var facebookBtn: UIButton!
//
//    @IBOutlet weak var appleBtn: UIButton!
//
//
//    @IBOutlet weak var backBtn: RoundButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.isNavigationBarHidden = true
//        setupUI()
//
//        appleBtn.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
//
//        googleBtn.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
//
//        facebookBtn.addTarget(self, action: #selector(signInFB), for: .touchUpInside)
//
//    }
////    MARK:SETUPUI
//    func setupUI() {
//        print("setupUI----")
//        DispatchQueue.main.async {
//            self.googleBtn.setCornerRadius()
//            self.appleBtn.setCornerRadius()
//            self.facebookBtn.setCornerRadius()
//        }
//    }
//    //MARK:FaceBook Login
//    @objc func signInFB(_ sender: Any) {
////        LoginManager().logIn(permissions: ["public_profile"], from: self) { result, error in
////           // Handle login result and update button text
////            print("REsult------\(result)")
////         }
//        LoginManager().logIn(permissions: ["public_profile"], from: self) { result, error in
//            if let error = error {
//                print("Facebook login error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let result = result, !result.isCancelled else {
//                print("Facebook login cancelled")
//                return
//            }
//
//            let token = result.token?.tokenString
//
//            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,email,first_name,last_name,picture,short_name,name,middle_name,name_format,age_range"], tokenString: token, version: nil, httpMethod: .get)
//            request.start { connection, result, error in
//                print("Result: \(result)")
//                if let error = error {
//                    print("Graph request error: \(error.localizedDescription)")
//                    return
//                }
//
//                if let userData = result as? [String: Any] {
//                    let email = userData["email"] as? String ?? ""
//                    let name = userData["name"] as? String ?? ""
//
//                    print("Facebook User Data:")
//                    print("Email: \(email)")
//                    print("Name: \(name)")
//
//
//                }
//            }
//        }
//
//    }
//
//       @objc func signInButtonPressed(_ sender: Any) {
//           GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//                       guard error == nil else { return }
//
//                     // If sign in succeeded, display the app's main content View.
//                       guard let signInResult = signInResult else { return }
//                       let user = signInResult.user
//
//                       let emailAddress = user.profile?.email
//                       let fullName = user.profile?.name
//                       let familyName = user.profile?.familyName
//                       let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//
//               print("data: \(emailAddress ?? "")")
//               print("data: \(fullName ?? "")")
//               print("data: \(familyName ?? "")")
//               print("data: \(profilePicUrl)")
//                   }
//       }
//
//    @objc func handleSignInWithApple() {
//            let provider = ASAuthorizationAppleIDProvider()
//            let request = provider.createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let controller = ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()
//        }
//    @IBAction func AlreadyHaveAccount(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
//        self.navigationController?.pushViewController(VC, animated: true)
//    }
//}
////MARK:AppleLogin
//extension ViewController: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            print("User ID: \(userIdentifier)")
//            print("Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
//            print("Email: \(email ?? "")")
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Apple Sign In Error: \(error.localizedDescription)")
//    }
//}
//
//extension ViewController: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
