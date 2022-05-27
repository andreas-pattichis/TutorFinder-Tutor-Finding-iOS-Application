//
//  EditReviewView.swift
//  TutorFind
//
//  Created by Andreas Loizides on 02/12/2021.
//

import SwiftUI

struct EditReviewView: View {
	@ObservedObject var review: ReviewViewModel
	@Binding var isShown: Bool
	
	let teacherName: String
    var body: some View {
//		NavigationView
		VStack{
			Form{
				TextField("Τίτλος", text: $review.model.title)
				TextField("Περιεχόμενο", text: $review.model.description)
				HStack{
					StarsView(rating: review.model.grade)
					Stepper("", onIncrement: {
						guard review.model.grade<5 else{return}
						withAnimation{
							review.model.grade+=0.5
						}
					} , onDecrement: {
						guard review.model.grade>0 else{return}
						withAnimation{
							review.model.grade-=0.5
						}
					} )
				}
			}
			
			Text("Καθηγήτρια/ής")
				.font(.footnote)
			Text(teacherName)
				.navigationTitle("Νεα Κριτική")
				.toolbar{
					ToolbarItemGroup(placement: .primaryAction){
						Button("Καταχώριση"){
							Task{
								if await review.updateModel(){
									DispatchQueue.main.async {
										self.isShown=false
									}
								}
								
							}
						}
					}
				}
		}
    }
}

struct EditReviewView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView{
		EditReviewView(review: ReviewViewModel(), isShown: .constant(true), teacherName: "ss")
		}
    }
}
