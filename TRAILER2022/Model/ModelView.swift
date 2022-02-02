//
//  ModelView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 29.01.22.
//

import SwiftUI
import FirebaseStorage
import FirebaseStorageSwift

//struct ModelView: View {
//
//    @StateObject private var mara = Mara()
//    @State var store = Storage.storage().reference()
//
//    let image =      Image("Esp")
//    var body: some View {
//        VStack {
//            List(mara.task) { valume in
//                Text("\(valume.number)")
//            }
//            List(mara.fire) { valume in
//                Text("\(valume.number)")
//            }
//
//            Button(action: {
//                              dataCodable()
//            }) {
//                Text("save To Firebase")
//                    .padding()
//            }
//        }
//    }
//    func dataCodable() {
//
//        let meta = StorageMetadata()
//            meta.contentType = "txt"
//        guard let encoder  = try? JSONEncoder().encode(mara.task) else { return}
//
//
//        do{
//            let _ = try! store.child("json-Dossi").putData(encoder , metadata: meta) { (metadata, err) in
//
//                guard let metadata = metadata else {
//                    print("error metadada ...")
//                    return
//                }
//
//                    DispatchQueue.main.async { [self] in
//                        store.child("json-Dossi").downloadURL{( url , err ) in
//                            guard let downloadURL = url else {
//                                print("error .. >> url")
//                                return
//                            }
//                            print("url >> \(downloadURL.relativeString)")
//                        }
//
//                    }
//            }
//        }catch{
//
//        }
//    }
//}


