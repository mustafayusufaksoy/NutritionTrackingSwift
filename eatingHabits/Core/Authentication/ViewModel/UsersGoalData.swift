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
                    // Kullanıcının adını, boyunu ve kilosunu güncelleyin
                    self?.fullname = data["fullname"] as? String ?? "Unknown"
                    self?.height = data["height"] as? Int ?? 0
                    self?.weight = data["weight"] as? Int ?? 0
                }
            } else {
                print("Document does not exist or failed to fetch data")
            }
        }
    }
}
