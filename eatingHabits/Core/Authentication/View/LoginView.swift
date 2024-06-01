import SwiftUI

struct SwiftUIView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel  // Correct usage

    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                Text("Hello!")
                    .font(.title)
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com",
                              isSecureField: false)
                        .autocapitalization(.none)
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Please Enter Password",
                              isSecureField: true)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                //signin button
                Button(action: {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }) {
                    HStack {
                        Text("Sign In")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44) // Use infinity for width to span the button across the screen and specify a reasonable height
                }
                .background(Color.blue) // Direct use of SwiftUI Color
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.horizontal, 24)
                
                Spacer()
                
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Dont have an account?")
                        Text("Sign Up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension SwiftUIView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

// SwiftUI Preview
struct View_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

