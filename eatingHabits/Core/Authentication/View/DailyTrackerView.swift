import SwiftUI

struct DailyTrackerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var usersGoalData: UsersGoalData // Add this

    struct Meal {
        var name: String
        var type: String
        var calories: Int
    }
    
    @State private var meals: [Meal] = [
        Meal(name: "Greek Salad", type: "Breakfast", calories: 200),
        Meal(name: "Chicken Stake", type: "Lunch", calories: 350),
        Meal(name: "Shredded Chicken", type: "Dinner", calories: 300)
    ]
    
    @State private var totalCalories = 850
    @State private var remainingCalories = 592

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello \(viewModel.currentUser?.fullname ?? "Yusuf"), how are you today?")
                    .font(.title)
                    .padding()
                HStack{
                    Text("Height: \(usersGoalData.height) cm")
                        .padding()
                    Text("Weight: \(usersGoalData.weight) kg")
                        .padding()
                }
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
                
                Button(action: {
                    // Implement the addition of new meals
                }) {
                    Text("+ Add New")
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .onAppear {
            usersGoalData.fetchUserData() // Görünüm yüklendiğinde kullanıcı verilerini çek
        }
    }
}

struct ProgressBar: View {
    var progress: Double
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(color)

                Rectangle()
                    .frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(45.0)
        }
    }
}

struct DailyTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTrackerView()
            .environmentObject(AuthViewModel()) // Ensure these are provided
    }
}
