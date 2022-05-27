package com.team10.tutorfind.models;


public enum UserType {
    student("Μαθητής"),
    teacher("Καθηγήτρια/τής");

    private String userType;

    UserType(String userType) {
        this.userType = userType;
    }

    public String getUserType() {
        return userType;
    }
}