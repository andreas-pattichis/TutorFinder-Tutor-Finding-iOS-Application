package com.team10.tutorfind.models;



public enum Taksi {
    any ("Οποιαδήποτε"),
    a ("Α'"),
    b ("Β'"),
    g ("Γ'");


    private String taksi;

    Taksi(String userType) {
        this.taksi = userType;
    }

    public String getSchoolType() {
        return taksi;
    }
}
