//
//  GameSettingsVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import MapKit
import Alamofire

class GameSettingsVC: UIViewController, PassingDataBack {
    
    
    @IBOutlet weak var miniBack: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var timeStepper: UIStepper!
    
    
    @IBOutlet weak var playerLimitLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    
    
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    
    @IBOutlet weak var doneButton: UIButton!
    var codesForGeo: CLLocationCoordinate2D?
    var gameName: String = ""
    var geoGo: Again?
    let call = CallingHandlers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        
        
    }
    
    func UISetup() {
        self.navigationController?.isNavigationBarHidden = true
        
        
        miniBack.layer.cornerRadius = 20
        mapView.layer.cornerRadius = 20
        gameTitle.text = gameName
        gameTitle.textAlignment = .center
        playerStepper.value = 3
        timeStepper.value = 1
        playerStepper.minimumValue = 3
        timeStepper.minimumValue = 1
        imageView.layer.cornerRadius = 20
        timeStepper.maximumValue = 120
        playerStepper.maximumValue = 50
        playerLimitLabel.text = "\(Int(playerStepper.value)) players"
        timeLimitLabel.text = "\(Int(timeStepper.value)) minute"
        let mapTapped = UITapGestureRecognizer(target: self, action: #selector(mapTappedFunc(gesture:)))
        mapView.addGestureRecognizer(mapTapped)
        mapView.isUserInteractionEnabled = true
        mapView.backgroundColor = UIColor.clear
        playerStepper.backgroundColor = UIColor(named: "ButtonColor")
        timeStepper.backgroundColor = UIColor(named: "ButtonColor")
        doneButton.layer.cornerRadius = 20
        
        
        if Singleton.shared.teamName != nil {
            gameTitle.text = Singleton.shared.teamName
            
        } else {
            gameTitle.text = "Create Game"
            
        }
        
        
    }
    
    @IBAction func timeStepperAction(_ sender: Any) {
        if timeStepper.value > 1 {
            timeLimitLabel.text = "\(Int(timeStepper.value)) minutes"
            
        } else if timeStepper.value == 1 {
            
            timeLimitLabel.text = "\(Int(timeStepper.value)) minute"
        }
        
    }
    
    @IBAction func playerStepperAction(_ sender: Any) {
        playerLimitLabel.text = "\(Int(playerStepper.value)) players"
        
    }
    
    @objc func mapTappedFunc(gesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toMap", sender: nil)
        
        
    }
    
    func sendData(_ cords: CLLocationCoordinate2D, _ zoom: MKCoordinateSpan, _ range: CLLocationDistance) {
        mapView.backgroundColor = .blue
        print(cords)
        print(zoom)
        print(range)
        
        
        let test = Again(cords: cords, zoom: zoom, range: range)
        geoGo = test
        
    }
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        if geoGo != nil {
            
            if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
                let bounds = [Float(geoGo!.zoom.latitudeDelta), Float(geoGo!.zoom.longitudeDelta)]
                
                
                
                let newParm = GameCreator(appleId: appleID, numPlayers: Float(playerStepper.value), time: Float(timeStepper.value), lat: Float(geoGo!.cords.latitude), long: Float(geoGo!.cords.longitude), rad: Float(geoGo!.range), bound: bounds)
                
                let newData = GameData(game: TrueGame(bound: [Double(bounds[0]), Double(bounds[1])], id: "", lat: Double(geoGo!.cords.latitude), long: Double(geoGo!.cords.longitude), rad: Double(geoGo!.range), memberLimit: Double(playerStepper.value), timeLimit: Double(timeStepper.value), players: []), numPlayers: Double(5))
                
                Singleton.shared.gameData = newData
                
                dismiss(animated: true, completion: {
                    self.call.createGame(newParm)
                    
                })
                
                
                
            } else {
                
                print("error")
                
            }
            
            
            
            
            
        } else {
            print("test")
            
        }
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let destVC = segue.destination as! GameLocPickVC
            destVC.delegate = self
        }
        
        
    }
    
}
