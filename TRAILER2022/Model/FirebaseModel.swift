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

struct Names : Codable{
    
    var authName    : String
    var authNumber  : String
    var authPhone   : String
    var treNumber   : String
    var serviceNote : String
    
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
    
    @Published var auth : String = ""
    @Published var taskTo   : AuthAll?
    @Published var taskFrom : AuthAll?
    @Published var fire = [Task]()
    @Published var info = [TrailerInfo]()
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
                        storage.child("json-Dossi").downloadURL{( url , err ) in
                            guard let downloadURL = url else {
                                print("error .. >> url")
                                return
                            }
                            print("url >> \(downloadURL.relativeString)")
                        }

                    }
            }
        }catch{

        }
    }
}



