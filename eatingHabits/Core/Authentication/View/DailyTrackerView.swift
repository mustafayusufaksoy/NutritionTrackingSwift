import SwiftUI

struct DailyTrackerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var usersGoalData: UsersGoalData
    
    // Meal.swift
    struct Meal: Identifiable, Codable {
            let id: String
            var name: String
            var type: String
            var calories: Int
            var imageUrl: String

            init(id: String = UUID().uuidString, name: String, type: String, calories: Int, imageUrl: String) {
                self.id = id
                self.name = name
                self.type = type
                self.calories = calories
                self.imageUrl = imageUrl
            }
        }



    
    @State private var meals: [Meal] = [
    
    ]
    
    private var totalCaloriesConsumed: Int {
        meals.reduce(0) { $0 + $1.calories }
    }
    
    private var totalCaloriesRequired: Int {
        Int(usersGoalData.calculateTDEE())
    }
    
    private var remainingCalories: Int {
        totalCaloriesRequired - totalCaloriesConsumed
    }
    
    var progress: Double {
        if totalCaloriesRequired == 0 {
            return 0
        }
        return Double(totalCaloriesConsumed) / Double(totalCaloriesRequired)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) { // Reduced the spacing between VStack elements
                Text("Hello \(viewModel.currentUser?.fullname ?? "Yusuf"), how are you today?")
                    .frame(alignment: .center)
                    .padding(.vertical, 8) // Reduced padding
                HStack(spacing: 20) { // Specified HStack spacing for uniformity
                    Text("Height: \(usersGoalData.height) cm")
                    Text("Weight: \(usersGoalData.weight) kg")
                }
                .padding(.horizontal, 10) // Reduced horizontal padding
                HStack(spacing: 20) { // Added spacing to separate the VStaxks
                    calorieVStack(title: "Daily Calorie Requirement: \(totalCaloriesRequired) Cal")
                    calorieVStack(title: "Total Calories Consumed: \(totalCaloriesConsumed) Cal")
                    calorieVStack(title: "Remaining Calories: \(remainingCalories) Cal")
                }
                .frame(height: 160) // Adjusted height
                
                ProgressBar(progress: progress, color: .blue)
                    .frame(height: 12) // Reduced the height of the progress bar
                    .padding(.horizontal)
                
                List {
                    ForEach(meals, id: \.name) { meal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(meal.name)
                                    .font(.headline)
                                Text(meal.type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(meal.calories) Cal")
                        }
                    }
                }
                
                NavigationLink(destination: FoodSelection(meals: $meals, usersGoalData: usersGoalData, viewMeal: MealViewModel())) {
                    Text("+ Add New")
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 8) // Reduced padding
            }
            .padding(10) // Reduced outer padding
            .onAppear {
                usersGoalData.fetchUserData()
            }
        }
    }
    
    @ViewBuilder
    func calorieVStack(title: String) -> some View {
        VStack {
            Text(title)
                .font(.system(.footnote, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(6) // Consistent padding
                .background {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color(.systemFill))
                }
                .accessibilityLabel(title) // Providing accessible labels for better screen reader support
        }
        .padding(.vertical, 6) // Consistent vertical padding
        .animation(.easeInOut, value: title) // Adding a subtle animation for better user experience when the values change
    }
    
    
}
struct ProgressBar: View {
    var progress: Double
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(color.opacity(0.3)) // Background color of the progress bar

                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .animation(.linear(duration: 0.3), value: progress) // Adding an animation to smooth the progress changes
            }
            .cornerRadius(45.0) // Making the corners rounded
        }
    }
}
    struct DailyTrackerView_Previews: PreviewProvider {
        static var previews: some View {
            DailyTrackerView()
                .environmentObject(AuthViewModel()) // Ensure these are provided
                .environmentObject(UsersGoalData())
        }
    }
    
