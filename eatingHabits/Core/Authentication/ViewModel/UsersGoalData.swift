import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor
class UsersGoalData: ObservableObject {
    @Published var fullname: String = ""
    @Published var height: Int = 0
    @Published var weight: Int = 0
    @Published var age: Int = 0 // Kullanıcının yaşını ekleyelim
    @Published var gender: String = "" // Kullanıcının cinsiyetini ekleyelim ("male" veya "female")
    @Published var activityLevel: String = "lightly active" // Varsayılan aktivite seviyesi
    @Published var totalCaloriesConsumed: Int = 0 // Günlük tüketilen kalori
    @Published var dailyCalorieRequirement: Int = 0 // Günlük kalori ihtiyacı
    
    private var db = Firestore.firestore()
    
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let docRef = db.collection("usersGoalData").document(userID)

        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    // Kullanıcının adını, boyunu, kilosunu, yaşını, cinsiyetini ve aktivite seviyesini güncelleyin
                    self?.fullname = data["fullname"] as? String ?? "Unknown"
                    self?.height = data["height"] as? Int ?? 0
                    self?.weight = data["weight"] as? Int ?? 0
                    self?.age = data["age"] as? Int ?? 0
                    self?.gender = data["gender"] as? String ?? ""
                    self?.activityLevel = data["activityLevel"] as? String ?? "lightly active"
                    self?.totalCaloriesConsumed = data["totalCaloriesConsumed"] as? Int ?? 0
                    self?.dailyCalorieRequirement = Int(self?.calculateTDEE() ?? 0.0)
                }
            } else {
                print("Document does not exist or failed to fetch data")
            }
        }
    }
    
    func calculateBMR() -> Double {
        if gender == "male" {
            return 88.362 + (13.397 * Double(weight)) + (4.799 * Double(height)) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * Double(weight)) + (3.098 * Double(height)) - (4.330 * Double(age))
        }
    }

    func calculateTDEE() -> Double {
        let bmr = calculateBMR()
        let activityMultipliers: [String: Double] = [
            "sedentary": 1.2,
            "lightly active": 1.375,
            "moderately active": 1.55,
            "very active": 1.725,
            "extra active": 1.9
        ]
        
        return bmr * (activityMultipliers[activityLevel] ?? 1.375)
    }
    
    func updateCaloriesConsumed(newMealCalories: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        totalCaloriesConsumed += newMealCalories
        
        db.collection("usersGoalData").document(userID).updateData([
            "totalCaloriesConsumed": totalCaloriesConsumed
        ]) { error in
            if let error = error {
                print("Error updating calories: \(error.localizedDescription)")
            } else {
                print("Calories successfully updated")
            }
        }
    }
}
