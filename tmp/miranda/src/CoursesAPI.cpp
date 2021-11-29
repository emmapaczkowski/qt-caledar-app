//
// Created by Hatim Belhadjhamida on 2020-11-22.
//

#include "CoursesAPI.h"
#include <nlohmann/json.hpp>
#include <cpr/cpr.h>
#include <string>
#include <iostream>
using json = nlohmann::json;



json CoursesAPI::Login(string Username, string Password) {
    string requestUrl = this->URL + "Login";


    cpr::Response k = cpr::Post(cpr::Url{requestUrl},
                                cpr::Payload{{"username", Username}, {"password", Password}});

    json j = json::parse(k.text);

    return j;
}

json CoursesAPI::GetTodaysCourses(string day, string month, string year, string icsURL) {
    string requestUrl = this->URL + "GetTodaysCourses";


    cpr::Response k = cpr::Post(cpr::Url{requestUrl},
                                cpr::Payload{{"icsUrl", icsURL}, {"Day", day}, {"Month", month}, {"Year", year }});

    json j = json::parse(k.text);

    return j;
}

json CoursesAPI::GetWeeksCourses(string icsURL) {
    string requestUrl = this->URL + "GetWeeksCourses";


    cpr::Response k = cpr::Post(cpr::Url{requestUrl},
                                cpr::Payload{{"icsUrl", icsURL}});

    json j = json::parse(k.text);

    return j;

    return json();
}




