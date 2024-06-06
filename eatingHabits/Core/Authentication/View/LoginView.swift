import SwiftUI

struct SwiftUIView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel  // Correct usage

    var body: some View {
        NavigationStack {
            // Top Image
            Image("food")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 356, height: 480)
                .clipped()
                .overlay(alignment: .topLeading) {
                    // Hero
                    VStack(alignment: .leading, spacing: 11) {
                        // App Icon
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .fill(.yellow)
                            .frame(width: 72, height: 72)
                            .clipped()
                            .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.12), radius: 8, x: 0, y: 4)
                            .overlay {
                                Image(systemName: "fork.knife")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 31, weight: .regular, design: .default))
                                    .foregroundStyle(Color(.systemBackground))
                            }
                        VStack(alignment: .leading, spacing: 1) {
                            Text("FitAI")
                                .font(.system(.largeTitle, weight: .medium))
                                .foregroundStyle(Color(.black))
                            Text("Welcome to the future")
                                .font(.system(.headline, weight: .medium))
                                .frame(width: 190, alignment: .leading)
                                .clipped()
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color(.black))
                        }
                    }
                    .padding()
                    .padding(.top, 42)
                }
                .overlay(alignment: .bottom) {
                    Group {
                        
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                }
                .padding()
                .padding(.top, 40)
                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
            VStack{
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

