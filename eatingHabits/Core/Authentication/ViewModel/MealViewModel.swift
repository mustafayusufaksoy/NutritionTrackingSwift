import FirebaseFirestore

class MealViewModel: ObservableObject {
    @Published var meals: [DailyTrackerView.Meal] = []

    private var db = Firestore.firestore()

    init() {
        fetchMeals()
    }

    func fetchMeals() {
        db.collection("meals").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.meals = documents.map { document in
                let data = document.data()
                return DailyTrackerView.Meal(
                    name: data["name"] as? String ?? "",
                    type: data["type"] as? String ?? "",
                    calories: data["calories"] as? Int ?? 0,
                    imageUrl: data["imageUrl"]  as? String ?? ""
                )
            }
        }
    }
}
