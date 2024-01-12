import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnSignout: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnEditProfile.layer.cornerRadius = 20.0
        btnSignout.layer.cornerRadius = 20.0
        setupBackButton()
        
        updateUI()
        
        loadUserData()
    }
    
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
    
    
    
    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
        
        let updateProfileVc = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        navigationController?.pushViewController(updateProfileVc, animated: true)
        
        
    }
    
    
    func updateUI()
    {
        if let user = Auth.auth().currentUser {
            lblUser.text = "Welcome \(user.email ?? "User")"
        }
    }
    
    
    //Custom Back button ------- start
    func setupBackButton() {
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "leftback"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let customBackButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc func backButtonTapped() {
        let signInVc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        navigationController?.pushViewController(signInVc, animated: true)
    }
    
    //Custom Back button ------- Stop
    
    
    func loadUserData() {
        
        let ref = Database.database().reference().child("users")

        guard let user = Auth.auth().currentUser else {
            return
        }

       ref.child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                // Safely unwrap profileImage from the optional chaining
                if let profilePictureString = userData["profilePicture"] as? String,
                   let imageData = Data(base64Encoded: profilePictureString),
                   let profileImage = UIImage(data: imageData),
                   let profileImageView = self.profileImage {

                    DispatchQueue.main.async {
                        profileImageView.image = profileImage
                    }
                } else {
                    print("Error: Could not load profile picture.")
                }

                if let username = userData["username"] as? String {
                    self.lblUser?.text = "Welcome, \(username)!"
                }
            } else {
                print("Error: Could not retrieve user data.")
            }
        }
    }

    
    
}
