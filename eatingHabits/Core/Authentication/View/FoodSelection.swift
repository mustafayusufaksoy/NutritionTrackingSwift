import SwiftUI
import SDWebImageSwiftUI  // Ensure this is imported to use WebImage

struct FoodSelection: View {
    @Binding var meals: [DailyTrackerView.Meal]
    @ObservedObject var usersGoalData: UsersGoalData
    @ObservedObject var viewMeal: MealViewModel
    
    @State private var showAlert = false
    @State private var selectedMealName = ""
    
    var body: some View {
        VStack {
            Text("Select a Meal")
                .font(.title)
                .padding()
            
            ScrollView {
                ForEach(viewMeal.meals, id: \.id) { meal in  // Make sure id is used for uniqueness
                    VStack(spacing: 2) {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: meal.imageUrl)) // Load image from URL
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 109, height: 90)
                                .clipped()
                                .cornerRadius(13)
                            
                            VStack(alignment: .leading) {
                                Text(meal.name)
                                    .font(.system(.callout, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(meal.type)
                                    .font(.system(.footnote))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(meal.calories) Cal")
                                    .font(.system(.caption, weight: .medium))
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            Button(action: {
                                self.addMeal(meal: meal)
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Meal Added"), message: Text("\(selectedMealName) has been added to your meals."), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Food Selection")
    }

    func addMeal(meal: DailyTrackerView.Meal) {
        meals.append(meal)
        usersGoalData.updateCaloriesConsumed(newMealCalories: meal.calories)
        selectedMealName = meal.name
        showAlert = true
    }
}

struct FoodSelection_Previews: PreviewProvider {
    static var previews: some View {
        // Ensure your preview data matches the expected data structure
        FoodSelection(meals: .constant([DailyTrackerView.Meal(id: "1", name: "Sample Meal", type: "Snack", calories: 100, imageUrl: "https://example.com/image.jpg")]), usersGoalData: UsersGoalData(), viewMeal: MealViewModel())
    }
}
