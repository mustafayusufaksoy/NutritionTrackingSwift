import SwiftUI
import Firebase

struct OnboardingView: View {
    @State private var gender: String = "male"
    @State private var height: Double = 173
    @State private var weight: Double = 72
    @State private var navigateToGoalSetting = false
    @State private var navigateToSkip = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showProfileView = false
    @State private var showAlert = false
    @State private var navigateToDailyTrackerView = false


    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome, \(viewModel.currentUser?.fullname ?? "Yusuf")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Image("user-2") // Replace "user-2" with the actual image asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding(.top, 20)
                
                HStack {
                    GenderSelectionButton(gender: $gender, label: "male")
                    GenderSelectionButton(gender: $gender, label: "female")
                    GenderSelectionButton(gender: $gender, label: "other")
                }
                .padding()
                
                Slider(value: $height, in: 140...200, step: 1)
                Text("Height \(Int(height))cm")
                    .fontWeight(.semibold)
                
                Slider(value: $weight, in: 40...150, step: 1)
                Text("Weight \(Int(weight))kg")
                    .fontWeight(.semibold)
                
                HStack{
                    Button("Continue") {
                        navigateToGoalSetting = true
                    }
                    Button("Skip") {
                        navigateToDailyTrackerView = true
                    }
                }
                .padding()
                .navigationDestination(isPresented: $navigateToGoalSetting) {
                    GoalSettingView(gender: gender, height: height, weight: weight)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .navigationDestination(isPresented: $navigateToDailyTrackerView) {
                    DailyTrackerView()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfileView = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(isPresented: $showProfileView) {
                ProfileView()
            }
            Spacer()
        }
    }
}

struct GenderSelectionButton: View {
    @Binding var gender: String
    let label: String

    var body: some View {
        Button(action: {
            self.gender = label
        }) {
            Text(label.capitalized)
                .foregroundColor(gender == label ? .white : .blue)
                .padding()
                .background(gender == label ? .blue : .clear)
                .cornerRadius(10)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct GoalSettingView: View {
    var gender: String
    var height: Double
    var weight: Double
    @State private var goalWeight: Double = 80
    @State private var navigateToDailyTrackerView = false
    @EnvironmentObject var viewModel: AuthViewModel

    func saveUserData() {
        let db = Firestore.firestore()
        let userData = [
            "gender": gender,
            "height": height,
            "weight": weight,
            "goalWeight": goalWeight,
            "id": viewModel.currentUser?.id ?? "",
            "fullname": viewModel.currentUser?.fullname ?? "Yusuf"
        ] as [String : Any]

        if let userID = viewModel.currentUser?.id, !userID.isEmpty {
            db.collection("usersGoalData").document(userID).setData(userData, merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated successfully")
                    navigateToDailyTrackerView = true
                }
            }
        } else {
            db.collection("usersGoalData").addDocument(data: userData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    navigateToDailyTrackerView = true
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Goals")
                    .font(.largeTitle)
                    .padding()

                Image(systemName: "target")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                Slider(value: $goalWeight, in: 50...150, step: 1)
                Text("Goal Weight \(Int(goalWeight))kg")
                    .fontWeight(.semibold)

                Button("Update") {
                    saveUserData()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .navigationDestination(isPresented: $navigateToDailyTrackerView) {
                    DailyTrackerView()
                }
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AuthViewModel())
    }
}
