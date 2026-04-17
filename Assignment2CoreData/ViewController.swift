import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    let stackView = UIStackView()
        
        // 2. Use the official SDK class instead of UIButton
        let googleButton = GIDSignInButton()
        
        let skipButton = UIButton(type: .system)

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            setupLayout()
        }

        func setupLayout() {
            stackView.axis = .vertical
            stackView.spacing = 15
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            // 3. Optional: Configure the button style
            // Options: .standard, .wide, .iconOnly
            googleButton.style = .wide
            googleButton.colorScheme = .light // or .dark
            
            // Note: GIDSignInButton doesn't use addTarget like a normal button.
            // You usually handle the sign-in logic via GIDSignIn.sharedInstance.signIn
            googleButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)

            skipButton.setTitle("Skip for Now", for: .normal)
            skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)

            view.addSubview(stackView)
            stackView.addArrangedSubview(googleButton)
            stackView.addArrangedSubview(skipButton)

            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stackView.widthAnchor.constraint(equalToConstant: 280)
            ])
        }
        
        @objc func handleSignIn() {
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                guard error == nil else { return }
                // If successful, move to the next screen
                self.didTapSkip()
            }
        }
        
        @objc func didTapSkip() {
            let mainVC = TableViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    
   
    
}

