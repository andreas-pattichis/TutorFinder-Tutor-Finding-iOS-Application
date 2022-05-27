package com.team10.tutorfind.models;


public enum SchoolType {
    any ("Οποιοδήποτε"),
    gymnasio ("Γυμνασίου"),
    lykeio ("Λυκείου");


    private String schoolType;

    SchoolType(String userType) {
        this.schoolType = userType;
    }

    public String getSchoolType() {
        return schoolType;
    }
}