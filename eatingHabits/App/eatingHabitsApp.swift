import SwiftUI
import Firebase


@main
struct eatingHabitsApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var viewData = UsersGoalData()
    @StateObject var viewMeal = MealViewModel()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())  // Injecting AuthViewModel
                .environmentObject(UsersGoalData())
                .environmentObject(MealViewModel())
        }
    }
}

