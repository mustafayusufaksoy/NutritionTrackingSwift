import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel  // Correct usage

    var body: some View {
        NavigationView {
            if viewModel.currentUser != nil {
                OnboardingView()
            } else {
                SwiftUIView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper navigation view on all devices
    }
}

// SwiftUI Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel()) // Assume AuthViewModel can simulate both states
    }
}
