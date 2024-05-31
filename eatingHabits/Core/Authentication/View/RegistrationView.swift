import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AuthViewModel

    var body: some View {
        VStack {
            Image("Designer")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com",
                          isSecureField: false)
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter Your Name",
                          isSecureField: false)
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Please Enter Password",
                          isSecureField: true)
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your Password",
                          isSecureField: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                        // Handle success, e.g., navigation or confirmation message
                    } catch {
                        // Handle error, e.g., show an alert to the user
                        print("Registration failed: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 24)

            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                HStack {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

// SwiftUI Preview
struct RegistrationView_Previews: PreviewProvider {  // Corrected Preview Provider Name
    static var previews: some View {
        RegistrationView()
    }
}
