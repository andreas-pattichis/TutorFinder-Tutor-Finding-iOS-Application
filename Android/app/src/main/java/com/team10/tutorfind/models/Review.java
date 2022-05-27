package com.team10.tutorfind.models;

import java.util.HashMap;
import java.util.Map;

public class Review {
//    var id: String = ""
//     var authorID = "" (studentID)
//    @Published var author = "" (studentName)
//    @Published var teacherID = ""
//    @Published var teacherName = ""
//    @Published var grade: Float = 0.0
//    @Published var title = ""
//    @Published var description = ""
//    @Published var date = Date() 22-11-2021 09:59

    String authorID="";
    String author="";
    String teacherID="";
    String teacherName="";
    float grade=0;
    String title="";
    String description="";
    String date="";

    public Map<String, Object> toMap() {
        HashMap<String, Object> result = new HashMap<>();

        result.put("author", author);
        result.put("authorID", authorID);
        result.put("teacherID", teacherID);
        result.put("teacherName", teacherName);
        result.put("grade", grade);
        result.put("title", title);
        result.put("description", description);
        result.put("date", date);

        return result;
    }

    public Review fromMap(Map<String, Object> m){
        String authID=(String) m.get("authorID");
        String auth=(String) m.get("author");
        String teID=(String) m.get("teacherID");
        String teName=(String) m.get("teacherName");
        float gr=(float) m.get("grade");
        String ti=(String) m.get("title");
        String des=(String) m.get("description");
        String da=(String) m.get("date");

        if(authID==null || auth==null || teID==null || teName==null || ti==null || des==null || da==null  )
            return null;
        else{
            this.authorID=authID;
            this.author=auth;
            this.teacherID=teID;
            this.teacherName=teName;
            this.grade=gr;
            this.title=ti;
            this.date=da;
        }

        return this;
    }


}
