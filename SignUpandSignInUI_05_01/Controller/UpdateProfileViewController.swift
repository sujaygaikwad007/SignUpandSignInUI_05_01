import UIKit
import FirebaseDatabase
import FirebaseAuth

class UpdateProfileViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var txtUpdateEmail: UITextField!
    @IBOutlet weak var txtUpdatePassword: UITextField!
    @IBOutlet weak var txtUpdateConfPassword: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var updateProfileImage: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    var databaseRef: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hideKeyboardTappedAround()
        
        setupBackButton()
        
        
        txtUpdateEmail.delegate = self
        txtUpdatePassword.delegate = self
        txtUpdateConfPassword.delegate = self
        imagePicker.delegate = self
        
        
        cornerRadiusTxtField()
        
        eyeIconTxtField(for: txtUpdatePassword, with: UIImageView())
        eyeIconTxtField(for: txtUpdateConfPassword, with: UIImageView())
        
        addIconToTextField(textField: txtUpdateEmail, iconName: "email")
        addIconToTextField(textField: txtUpdatePassword, iconName: "open-lock")
        addIconToTextField(textField: txtUpdateConfPassword, iconName: "open-lock")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        updateProfileImage.addGestureRecognizer(tapGesture)
        updateProfileImage.isUserInteractionEnabled = true
        
        databaseRef = Database.database().reference()
        
        
        
        
    }
    
    
    
    
    @IBAction func btnUpdateTapped(_ sender: UIButton) {
        validation()
        
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
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    //Custom Back button ------- Stop
    
    
    
    //Profile Picture--- start
    
    @objc func profileImageTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func uploadProfilePicture() {
        guard let user = Auth.auth().currentUser,
              let imageData = updateProfileImage.image?.jpegData(compressionQuality: 0.5) else {
                  return
              }
        
        let base64ImageString = imageData.base64EncodedString()
        let databaseRef = Database.database().reference().child("users").child(user.uid).child("profilePicture")
        databaseRef.setValue(base64ImageString)
        
        
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            updateProfileImage.contentMode = .scaleAspectFit
            updateProfileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
