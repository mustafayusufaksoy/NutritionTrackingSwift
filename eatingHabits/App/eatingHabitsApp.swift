import SwiftUI
import Firebase


@main
struct eatingHabitsApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())  // Injecting AuthViewModel
        }
    }
}

