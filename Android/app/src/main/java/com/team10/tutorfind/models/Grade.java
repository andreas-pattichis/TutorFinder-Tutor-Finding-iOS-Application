package com.team10.tutorfind.models;

import java.util.HashMap;
import java.util.Map;

public class Grade {
//    var id = ""
//    var studentID = ""
//    var professorID = ""
//    var studentName = ""
//    var professorName = ""
//    var grade: Double = 0.0
//    var title = ""
//    var comments = ""
//    var courseName = ""
//    var date = Date() 22-11-2021 09:59

    String id="";
    String studentID="";
    String professorID="";
    String studentName="";
    String professorName="";
    float grade=0;
    String title="";
    String comments="";
    String courseName="";
    String date="";

    public Map<String, Object> toMap() {
        HashMap<String, Object> result = new HashMap<>();

        result.put("id", id);
        result.put("studentID", studentID);
        result.put("professorID", professorID);
        result.put("studentName", studentName);
        result.put("professorName", professorName);
        result.put("grade", grade);
        result.put("title", title);
        result.put("comments", comments);
        result.put("courseName", courseName);
        result.put("date", date);

        return result;
    }

    public Grade fromMap(Map<String, Object> m) {
        String id = (String) m.get("id");
        String studentID = (String) m.get("studentID");
        String professorID = (String) m.get("professorID");
        String studentName = (String) m.get("studentName");
        String professorName = (String) m.get("professorName");
        float grade = (float) m.get("grade");
        String title = (String) m.get("title");
        String comments = (String) m.get("comments");
        String courseN = (String) m.get("courseName");
        String date = (String) m.get("date");

        if (id == null || studentID == null || professorID == null || studentName == null || professorName == null || title == null || comments == null || courseN == null || date == null)
            return null;
        else {
            this.id = id;
            this.studentID = studentID;
            this.professorID = professorID;
            this.studentName = studentName;
            this.professorName = professorName;
            this.grade = grade;
            this.title = title;
            this.comments = comments;
            this.courseName = courseN;
            this.date = date;
        }

        return this;
    }
}
