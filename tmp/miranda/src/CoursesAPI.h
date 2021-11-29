//
// Created by Hatim Belhadjhamida on 2020-11-22.
//

#include <string>
#include <nlohmann/json.hpp>
// for convenience
using json = nlohmann::json;

#ifndef APICLASS_COURSESAPI_H
#define APICLASS_COURSESAPI_H

using namespace std;


class CoursesAPI {
public:
    json Login(string Username, string Password);
    json GetTodaysCourses(string day, string month, string year, string icsURL);
    json GetWeeksCourses(string icsURL);

private:
    string URL = "http://miranda.caslab.queensu.ca/";



};


#endif //APICLASS_COURSESAPI_H
