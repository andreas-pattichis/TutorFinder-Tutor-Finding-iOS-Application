package com.team10.tutorfind.models;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class CourseModel{


    Date startTime = new Date();     //"14:48"
    String id = "";                  //"\(UUID())"
    String title = "";
    String teacherID = "";
    String teacherName = "";
    int lengthInMinutes = 0;

    Frequency frequency;  //implementation of enum Frequency required
    Taksi taksi; //enum
    SchoolType schoolType; //enum
    ClassType classType; //enum


    public Map<String, Object> toMap() {
        HashMap<String, Object> result = new HashMap<>();

        result.put("title", title);
        result.put("id", id);
        result.put("startTime",startTime.toString());
        result.put("teacher", teacherName);
        result.put("teacherID",teacherID);
        result.put("frequency",frequency.toString());
        result.put("classType",classType.toString());
        result.put("lengthInMinutes",lengthInMinutes);
        result.put("taksi",taksi.toString());

        return result;
    }

}
