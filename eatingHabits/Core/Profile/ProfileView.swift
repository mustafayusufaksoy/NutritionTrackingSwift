//
//  ProfileView.swift
//  eatingHabits
//
//  Created by yusuf on 30.05.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.semibold)
                            .frame(width: 72,height: 72)
                            .background(Color(.systemGray))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading, spacing: 4){
                        
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .accentColor(.gray)
                        }
                        
                    }
                }
                Section("General"){
                    HStack {
                        SettingsRowView(imageName: "gear", title: "version", tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                
                }
                Section("Account"){
                    Button {
                        viewModel.signOut()
                    } label : {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    Button {
                        print("Sign Out")
                    } label : {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Delete Accaount", tintColor: .red)
                    }
                    
                }
            }

        }
    }
}

#Preview {
    ProfileView()
}
