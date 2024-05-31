import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color

    var body: some View {
        HStack(spacing:12) {
            Image(systemName: imageName) // Assumes you are using SF Symbols
                .foregroundColor(tintColor)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .imageScale(.small)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

// SwiftUI Preview
struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
            .previewLayout(.sizeThatFits)
    }
}
