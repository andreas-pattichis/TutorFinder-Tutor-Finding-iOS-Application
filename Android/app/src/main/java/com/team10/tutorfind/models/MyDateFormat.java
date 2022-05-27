package com.team10.tutorfind.models;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


public class MyDateFormat {


    LocalDateTime dateTime;
    DateTimeFormatter formatter;


    public MyDateFormat(String datetime) {

        formatter=DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        LocalDateTime dateTime = LocalDateTime.parse(datetime, formatter);
    }

    public String toString() {
        return dateTime.format(formatter);
    }

}