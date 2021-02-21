//
//  CallingHandlers.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import Foundation
import Alamofire
import SwiftLocation
import MapKit
import CoreLocation
import SwiftyJSON


class CallingHandlers {
    
    
    func createGame(_ data: GameCreator) {
        
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        
        //  let json = JSON(["appleId":aID,"numPlayers":data.numPlayers,"time": "\(data.time)"])
        
        
        
        
        let parameters: Parameters = [
            "appleId": aID!,
            "numPlayers": data.numPlayers,
            "time": "\(data.time)",
            "lat":data.lat,
            "long":data.long,
            "rad":data.rad,
            "bound":data.bound
            
        ]
        
        
        
        
        AF.request("http://camera-shy.space/api/createGame", method: .post, parameters: parameters).validate().responseDecodable(of: gameID.self) { (response) in
            guard let responses = response.value else { return }
            print(responses.gameId)
            Singleton.shared.gameID = responses.gameId
            
            DispatchQueue.main.async {
                let dataDataDict:[String: String] = ["gameId": responses.gameId]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hostGameStart"), object: nil, userInfo: dataDataDict)
                
            }
            
        }
        
        
        
    }
    
    
    func occasionalPost(_ data: OccPost) {
        
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "gameId":data.gameId,
            "appleId": aID!,
            "lat":data.loc.lat,
            "long":data.loc.long
            
            
        ]
        
        
        AF.request("http://camera-shy.space/api/loc", method: .post, parameters: parameters).responseJSON { (res) in
            print(res)
        }
        
        
        
        //            .validate().responseDecodable(of: [LatLong].self) { (response) in
        //            guard let responses = response.value else {  print(response)
        //                return }
        //            print(responses)
        //
        //            DispatchQueue.main.async {
        //               let dataDataDict:[String: [LatLong]] = ["userUpdates": responses]
        //               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdates"), object: nil, userInfo: dataDataDict)
        //
        //            }
        //
        //    }
        
        
        
    }
    
    
    func onPlayerJoin(_ gameID: String) {
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "appleId": aID!,
            "gameId": gameID
        ]
        //   print(gameID)
        
        
        AF.request("http://camera-shy.space/api/join", method: .get, parameters: parameters).validate().responseDecodable(of: GameData.self) { (response) in
            guard let responses = response.value else { return }
            print(responses)
            
            DispatchQueue.main.async {
                
                Singleton.shared.gameID = gameID
                Singleton.shared.gameData = responses
                let dataDataDict:[String: GameData] = ["userUpdates": responses]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameInfo"), object: nil, userInfo: dataDataDict)
                print("hello")
            }
            
        }
    }
    
    
    func onPlayerLeave() {
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        
        let parameters: Parameters = [
            "appleId": aID!,
            "gameId": Singleton.shared.gameID!
        ]
        
        
        AF.request("http://camera-shy.space/api/leave", method: .get, parameters: parameters).response { (test) in
            print(test)
        }
        
        
    }
    
    func cancelGame() {
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "appleId": aID!,
            "gameId": Singleton.shared.gameID!
        ]
        
        
        AF.request("http://camera-shy.space/api/cancel", method: .get, parameters: parameters).response { (test) in
            print(test)
        }
        
        
        
        
    }
    
    
    
    
    
    //        validate().responseDecodable(of: gameID.self) { (response) in
    //            guard let responses = response.value else { return }
    //            print(responses.gameId)
    //            Singleton.shared.gameID = responses.gameId
    //
    //            DispatchQueue.main.async {
    //                let dataDataDict:[String: String] = ["gameId": responses.gameId]
    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameID"), object: nil, userInfo: dataDataDict)
    //
    //            }
    //
    //    }
    
    
    
    
    
    
}
