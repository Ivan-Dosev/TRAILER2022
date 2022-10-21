//
//  FirebaseModel.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 29.01.22.
//
import UniformTypeIdentifiers
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseAuth
import Firebase
import SwiftUI
import Combine
import CryptoKit
import web3swift
import PromiseKit

struct Names : Codable{
    
    var authName    : String
    var authNumber  : String
    var authPhone   : String
    var treNumber   : String
    var serviceNote : String
    
}

struct Characteristic: Identifiable , Codable {
    var id = UUID().uuidString
    var authNumber  : String
    var modelTre    : String
    var colorTre    : String
    var dateTre     : String
    var scanner     : String
}

struct TrailerInfo : Codable, Identifiable {
    
                var id = UUID().uuidString
                var fromName : Names?
                var toName   : Names?
                var date     : String

}

struct Task : Codable, Identifiable {
    
                var id = UUID().uuidString
                var number : String

}

class Mara : ObservableObject  {
    

    var cancellable = Set<AnyCancellable>()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    @Published var verifyString = ""
    @Published var isInfo : Bool = false
    @Published var auth : String = ""
    @Published var taskTo   : AuthAll?
    @Published var taskFrom : AuthAll?
    @Published var fire = [Task]()
    @Published var info = [TrailerInfo](){
        didSet{
            if isInfo{
                
                verifyHash()
                self.isInfo = false
                
            }
        }
    }
    @Published var allTre        : [Characteristic] = []
    @Published var isID          : Bool = false {
        didSet{
            if isID && !treID.isEmpty {
                chackauthName(authNumber: charScener)
            }
        }
    }
    @Published var treID         : String = ""
    @Published var charScener    : String = ""
    @Published var isValidButton : Bool = false
    @Published var isTrailer: Bool = false
    @Published var urlTrailer: String = ""
    @Published var trailerNumber : String? {
        didSet{
            loadURL(name: trailerNumber! )
        }
    }
    
    init(){
      //  loadData()
        store()
        auth_DD()
       loadAllTre()
    }
    
    func verifyHash() {
        
        guard let encoder  = try? JSONEncoder().encode(info) else { return}
        let  dossihashedValue = "\(SHA256.hash(data: encoder ))"
        
        contractAddress = trailerNumber!
        wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"GanacheWallet")
        contract = ProjectContract(wallet: wallet!, contractString: contractAddress)

        
        getProjectString(nomer: 0) { str in
            
            if str == dossihashedValue {
                self.verifyString = ""
            }else{
                self.verifyString = "Problem !!!"
            }
                 print("srt :... \(str)")
                 print("dosi:... \(dossihashedValue)")
                
            }
    }
     
    func loadURL(name: String) {
        DispatchQueue.main.async { [self] in
            storage.child(name).downloadURL{( url , err ) in
                guard let downloadURL = url else { return }
                self.urlTrailer = downloadURL.relativeString
                store()
            }
        }
    }
    
    func loadAllTre() {

        db.collection("ФTRE").whereField("authNumber", isEqualTo: auth).addSnapshotListener{ [self] (snapShot, err) in
    
            guard let document = snapShot?.documents else { return }
            print("document.count = \(document.count)")
            self.allTre = document.compactMap{ doc -> Characteristic in
               
                do{
                    let arda = try! doc.data(as: Characteristic.self)
                    return arda!
                    
                }catch{
                    print("error..>>")
                }
            }
        }
    }
    
    
    func isCharacteristic(characteristic: Characteristic) {
          self.isID = false
          self.treID = ""
        
        DispatchQueue.main.async { [self] in
            storage.child(characteristic.scanner).downloadURL{( url , err ) in
                if let downloadURL = url {
                    db.collection("ФTRE").whereField("scanner", isEqualTo: characteristic.scanner).addSnapshotListener{ [self] (snapShot, err) in
                      guard let document = snapShot?.documents else { return }
                        document.map{ queryDocument  in
                            print(">>>\(queryDocument.documentID)")
                            self.treID = "\(queryDocument.documentID)"
                            self.charScener = characteristic.authNumber
                          //    self.isID = true
                          //  chackauthName(authNumber: characteristic.authNumber)
                        
                        }
                    }
                }
                else {
                    saveCaracteristic(characteristic: characteristic)
                 
                }
             }
           }
        
    }
    
    
    
    func chackauthName(authNumber: String) {
        
        
        print("of off.. ")
        do{
            let _ = try! db.collection("ФTRE").document(self.treID).updateData(["authNumber": authNumber]) { err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }catch{}

    }
    
     func saveCaracteristic(characteristic: Characteristic){
         
   
         do{
             let _ = try db.collection("ФTRE").addDocument(from: characteristic)
   
         }catch{
             fatalError("unable to encoding task")
         }
   
   
     }
    
    
    func addInfo(infoFrom: Names, infoTo: Names){
        
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let da_te = formatter1.string(from: today)
        
        let trailer = TrailerInfo(fromName: infoFrom, toName: infoTo, date: da_te)
        info.append(trailer)
        
    }
    
    func auth_DD(){
        self.auth = Auth.auth().currentUser!.uid
    }
    
    func loadDataFrom(name: String){
        db.collection(name).addSnapshotListener{( snap , err ) in
            guard let document = snap?.documents else{
                print("No document")
                return
            }
                           document.map{ queryDocument  in
                let data = queryDocument.data()
                let authNumber = data["authNumber"] as? String ?? ""
                let authPhone = data["authPhone"] as? String ?? ""
                let authName = data["authName"] as? String ?? ""
                
                self.taskFrom = AuthAll(authNumber: authNumber, authPhone: authPhone, authName: authName)
            }
        }
    }
    
    func loadData(){
        db.collection(auth).addSnapshotListener{( snap , err ) in
            guard let document = snap?.documents else{
                print("No document")
                return
            }
                    document.map{ queryDocument  in
                let data = queryDocument.data()
                let authNumber = data["authNumber"] as? String ?? ""
                let authPhone = data["authPhone"] as? String ?? ""
                let authName = data["authName"] as? String ?? ""
                
                self.taskTo =  AuthAll(authNumber: authNumber, authPhone: authPhone, authName: authName)
            }
        }
    }
    
    func   store() {
        
//https://firebasestorage.googleapis.com/v0/b/tihapp-7a201.appspot.com/o/json-D?alt=media&token=79d10efe-8e75-499a-a515-de75e41724ac
        
        guard let url = URL(string:  self.urlTrailer) else {
            print("No url....................")
            return}
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response)-> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else { throw URLError(.badServerResponse)}
                print("\(data)")
                return data
            }
            .decode(type: [TrailerInfo].self, decoder: JSONDecoder())
            .sink { completion  in
                                         print("\(completion)")
            } receiveValue: { [weak self] returnedTask in
                self?.info = returnedTask
            }
            .store(in: &cancellable)
    }
    
    func dataCodable() {

        let meta = StorageMetadata()
            meta.contentType = "txt"
        guard let encoder  = try? JSONEncoder().encode(info) else { return}
             

        do{
            let _ = try! storage.child(trailerNumber!).putData(encoder , metadata: meta) { (metadata, err) in

                guard let metadata = metadata else {
                    print("error metadada ...")
                    return
                }

                    DispatchQueue.main.async { [self] in
                        storage.child(trailerNumber!).downloadURL{( url , err ) in
                            guard let downloadURL = url else {
                                print("error .. >> url")
                                return
                            }
                            print("url >> \(downloadURL.relativeString)")
                            do{
                                let data = try  NSData(contentsOf: downloadURL)
                           
                                let hashedValue = SHA256.hash(data: data! )
                                print("Hashed Value: \(hashedValue)")
                             
                                contractAddress = trailerNumber!
                                print(">>>>>")
                                print( contractAddress)
                                
                                wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"GanacheWallet")
                          
                                contract = ProjectContract(wallet: wallet!, contractString: contractAddress)
                                
                                createNewProject( hashedValue: hashedValue)
                                
                            }catch{ print("no  > Hashed Value")}
                        }

                    }
            }
        }catch{

        }
    }
    
    func createNewProject( hashedValue: SHA256.Digest) {
        
        let projectEnd = "\(hashedValue)"

        let parameters = [projectEnd] as [AnyObject]
        firstly {
            // Call contract method
            callContractMethod(method: .projectContract, parameters: parameters,password: "dakata_7b")
        }.done { response in
            // print out response
            print("createNewProject response \(response)")
            // Call out get projectTitle
            self.getProjectTitle()
        }
    }

    func getProjectTitle() {
        let parameters = [] as [AnyObject]
        firstly {
            // Call contract method
            callContractMethod(method: .getProjectTitle, parameters: parameters,password: nil)
        }.done { response in
            // print out response
            print("getProjectTitle response \(response)")
        }
    }
    func getProjectString(nomer: Int, onDossi: @escaping (String) -> Void){
        let parameters = [] as [AnyObject]
      
        firstly {
            // Call contract method
            callContractMethodDossi(nomer: nomer ,method: .getProjectTitle, parameters: parameters,password: nil) { str in
                print("Dossi ... \(str as String )")

                   onDossi(str)
              
            }
        }.done { response in
            // print out response
            print("getProjectTitle response \(response)")
        }
    }
}



