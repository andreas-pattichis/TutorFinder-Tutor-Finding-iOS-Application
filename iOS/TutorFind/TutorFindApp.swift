//
//  TutorFindApp.swift
//  TutorFind
//
//  Created by Andreas Loizides on 23/11/2021.
//

import SwiftUI
import Firebase

@main
struct TutorFindApp: App {
	init(){
		FirebaseApp.configure()
		GlobalConfigurator.main.initialize()
	}
	@ObservedObject var user = UserVM.currentUser
	var body: some Scene {
		WindowGroup {
			ContentView()
				.alert(user.alertMessage, isPresented: $user.alert, actions: {})
			
				.sheet(isPresented: $user.showingRegisterView){
					
					NavigationView{
						UserRegisterView(isShown: $user.showingRegisterView)
					}
				}
				.onAppear{
					
					if UserVM.currentUser.isSignedIn{
						
						print("appears to be signed in..")
						
						if let userID = Auth.auth().currentUser?.uid{
							
							print("User \(userID) is indeed signed in")
							
														UserVM.currentUser.configureForLoggedInUser(userID: userID)
						}else{
							print("Not actually logged in.. signing out")
							UserVM.currentUser.logout()
						}
					}
				}
		}
		
	}
}
