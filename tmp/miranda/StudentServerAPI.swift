//
//  StudentServerAPI.swift
//  Mountain Leopard
//
//  Created by Hatim Belhadjhamida on 2020-02-28.
//  Copyright © 2020 Hatim Belhadjhamida. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class StudentServerAPI{
    
    var URL = "http://qlink-env.3nffg3f25u.us-east-2.elasticbeanstalk.com/"
    
    init() {
    }
    
    
    func GetTodaysCourses(day: String, month: String, year: String, icsUrl: String ,completionBlock:@escaping ([Course]) -> ()) {
        
        
    
         var datas: [Course] = []
         var url = self.URL + "GetTodaysCourses"
        
       AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(icsUrl.data(using: .utf8)!, withName: "icsUrl")
            multipartFormData.append(day.data(using: .utf8)!, withName: "Day")
            multipartFormData.append(month.data(using: .utf8)!, withName: "Month")
            multipartFormData.append(year.data(using: .utf8)!, withName: "Year")
        }, to: url)
            .responseJSON { response in
                var dataTest = JSON(response.data)
                                       
           for ele in dataTest{
               let courseName = ele.0.description
               let Location = ele.1["Location"].description
               let starts = ele.1["Starts"].description
               let ends = ele.1["Ends"].description
       
               datas.append(Course(courseName: courseName, Location: Location, startDate: starts, endDate: ends, days: [:]))
           }
                

           completionBlock(organizeCourses(courses: datas))
            }

           
        }
    
    
    func GetWeeksCourses(icsUrl: String, completionBlock:@escaping ([Course]) -> ()) {
     
     var datas: [Course] = []
        
        var url = self.URL + "GetWeeksCourses"
        
    
     
    AF.upload(multipartFormData: { multipartFormData in
          multipartFormData.append(icsUrl.data(using: .utf8)!, withName: "icsUrl")
     }, to: url)
         .responseJSON { response in
            
            var dataTest = JSON(response.data)
                     
                     
                     
                     for ele in dataTest{
                         let courseName = ele.0.description
                         let Location = ele.1["Location"].description
                         let times = ele.1["Dates"]
                         
                      
                         
                         var dictDays: [String:[String]] = [:]
                         
                         for eleTime in times{
                             dictDays[eleTime.0] = eleTime.1.arrayObject as? [String]
                             
                         }
                         
                     datas.append(Course(courseName: courseName, Location: Location, startDate: "", endDate: "", days: dictDays ))
                     }
                     
                 completionBlock(datas)
                 
                 
        }
     
    
     }
    
    
    
    func Login(usernameText: String, passwordText: String, completionBlock:@escaping ([String:String]) -> ()) {
        
        var url = self.URL + "Login"
        
        
        
      AF.upload(multipartFormData: { multipartFormData in
         multipartFormData.append(usernameText.data(using: .utf8)!, withName: "username")
         multipartFormData.append(passwordText.data(using: .utf8)!, withName: "password")
      }, to: url)
          .responseJSON { response in
                        
                     
                        guard let loginResponse = response.value as? [String:String] else{
                            
                            print("Error: \(response.error)")
                            return
                        }
                        
                        completionBlock(loginResponse)
                
        }
    }
    
    func  GetMealPlan(usernameText: String, passwordText: String, completionBlock:@escaping ([String:String]) -> ()) {
        
        var url = self.URL + "GetMealPlan"
        
       AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(usernameText.data(using: .utf8)!, withName: "username")
                multipartFormData.append(passwordText.data(using: .utf8)!, withName: "password")
        },
            to: url)
            .responseJSON { response in
                        guard let loginResponse = response.value as? [String:String] else{
                            
                            print("Error: \(response.error)")
                            return
                        }
                        
                        completionBlock(loginResponse)
                        
                    }
    }
    
    
    func Ban_Menu_Current(completionBlock:@escaping ([JSON]) -> ()){
        
        var url = self.URL + "Ban-Menu-Current"
        
        var menus: [JSON] = []
        
       AF.request(url).responseJSON { response in
                               guard let value = response.value
                                else{
                                   
                                   print("Error: \(response.error)")
                                   return
                               }
                            var dataTest = JSON(response.data)
                             menus.append(dataTest["MENUS"]["0"])
                             menus.append(dataTest["MENUS"]["1"])
                             menus.append(dataTest["MENUS"]["2"])
                                                           
                             completionBlock(menus)
                            
                            
                            
                            completionBlock(menus)
                               
                           }
    }
        
    
    func Leonard_Menu_Current(completionBlock:@escaping ([JSON]) -> ()){
        
        var url = self.URL + "Leonard-Menu-Current"
        
        var menus: [JSON] = []
        
        AF.request(url).responseJSON { response in
                               guard let value  = response.value else{
                                   
                                   print("Error: \(response.error)")
                                   return
                               }
                               
                              var dataTest = JSON(response.data)
                               
                            menus.append(dataTest["MENUS"]["0"])
                            menus.append(dataTest["MENUS"]["1"])
                            menus.append(dataTest["MENUS"]["2"])
                               
                               completionBlock(menus)
                               
                           }
        
        
    }
    
    func Jean_Royce_Menu_Current(completionBlock:@escaping ([JSON]) -> ()){
        
        var url = self.URL + "Jean-Royce-Menu-Current"
        var menus: [JSON] = []
        
        AF.request(url).responseJSON { response in
                               guard let Response = response.value as? [String:String] else{
                                   
                                   print("Error: \(response.error)")
                                   return
                                }
                               var dataTest = JSON(response.data)
                                menus.append(dataTest["MENUS"]["0"])
                                menus.append(dataTest["MENUS"]["1"])
                                menus.append(dataTest["MENUS"]["2"])
                                
                                completionBlock(menus)
                                                          
                                                          
                                                          
                                                        
                                                             
                                                         }
        
        }
    
    }


