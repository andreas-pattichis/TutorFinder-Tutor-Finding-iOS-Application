
import SwiftUI
import Firebase
@available(iOS 15.0, *)
struct ContentView: View {
	@ObservedObject var user = UserVM.currentUser
	var body: some View {
		if user.isSignedIn{
			TabView{
				NavigationView{
					MyCoursesView()
				}
				.tabItem{
					Label("Αρχική", systemImage: "house")
				}
				NavigationView{
					CalendarView()
				}
				.tabItem{
					Label("Εβδομάδα", systemImage: "calendar.circle")
				}
				NavigationView{
//					if user.model.userType == .student{
//					GradesView()
//					}else{
//						GradesViewProfessor()
//					}
					GradesView()
				}
				.tabItem{
					Label("Βαθμολογίες", systemImage: "pencil.circle")
				}
				NavigationView{
					UserView()
						.toolbar{
							ToolbarItemGroup(placement: .navigationBarLeading){
								Button("Αποσύνδεση"){
									user.logout()
								}
							}
						}
				}
				.tabItem{
					Label("Εγώ", systemImage: "person.circle")
				}
				if user.model.userType == .teacher{
					NavigationView{
						NewCourseView()
					}
					.tabItem{
						Label("Νέο Ακροατήριο", systemImage: "note.text.badge.plus")
					}
				}else{
					NavigationView{
						SearchView()
					}
					.tabItem{
						Label("Εύρεση μαθημάτων", systemImage: "magnifyingglass.circle")
					}
				}
			}
		}else{
			UserSignInView()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
