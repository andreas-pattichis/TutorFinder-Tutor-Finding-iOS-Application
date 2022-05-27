package com.team10.tutorfind.models;



public enum ClassType {
    dontCare ("Οποιοδήποτε"),
    biology ("Βιολογία"),
    nea ("Νέα Ελληνικά"),
    math ("Μαθηματικά"),
    archaia ("Αρχαία"),
    fysiki ("Φυσική"),
    cs ("Πληροφορική");

    private String classType;

    ClassType(String userType) {
        this.classType = userType;
    }

    public String getClassType() {
        return classType;
    }
}