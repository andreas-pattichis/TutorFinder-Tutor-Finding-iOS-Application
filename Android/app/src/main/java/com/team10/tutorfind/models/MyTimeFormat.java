package com.team10.tutorfind.models;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


public class MyTimeFormat {

    LocalDateTime dateTime;
    DateTimeFormatter formatter;


    public MyTimeFormat(String time) {

        formatter=DateTimeFormatter.ofPattern("HH:mm");
        LocalDateTime dateTime = LocalDateTime.parse(time, formatter);
    }

    public String toString() {
        return dateTime.format(formatter);
    }

}