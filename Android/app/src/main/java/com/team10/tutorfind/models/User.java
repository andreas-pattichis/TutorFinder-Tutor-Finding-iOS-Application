package com.team10.tutorfind.models;

public class User {
//    @Published var email = ""
//    @Published var password = ""
//    @Published var firstName = ""
//    @Published var lastName = ""
//    @Published var userType: UserType = .student
//    @Published var phoneNumber: Int = 0
    String firstName;
    String lastName;

    String fullName(){
        return firstName+" "+lastName;
    }
}
