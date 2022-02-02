//
//  Adress.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct Adress: View {
    
    let db = Firestore.firestore()
  
    @State var isShow : Bool   = false
    @State var text   : String = ""
    @State var ccode  : String = ""
    @State var no     : String = ""
    @State var code   : String = ""
    @State var ID     : String = ""
    @State var alert  : Bool   = false
    @State var msg    : String = ""
    @State var name   : String = ""
  
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack(alignment: .center , spacing: 0) {
                    Image("BCRL")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height / 4)

                    VStack( alignment: .center , spacing: 10){
                        

                     
                        Text("За да използвате приложението\nтрябва да се регистрирате\nс вашия телефонен номер\n")
                          
                        Text("Ако регистрацията е успешна\nще получите код за достъп")
                          
                        TextField("your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        VStack(alignment: .leading, spacing: 10) {

                            HStack{
                                TextField("phone namber", text: $no)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 200)
                                Spacer()
                            }
                            HStack{
                                TextField("+cod", text: $ccode)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 100)
                                Spacer()
                                if notEmpty() {
                                    Button(action: {
                                                              authentication()
                                    }) {
                                        Text(" send ")
                                            .padding()
                                            .frame(width: 100, height: 30)
                                            .modifier(CircleButton())

                                    }
                                }
                            }
                        }
                        
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding()
                        .frame(width: geometry.size.width, height: geometry.size.height / 2.5)
                        .offset(y: -50)
                  
                    
                    if isShow {
                        VStack(spacing: 0){


                            HStack(alignment: .center) {
                                
                                Button(action: {

                                                  self.isShow = false
                                }) {
                                    Text("cancel")
                                        .padding()
                                        .frame(width: 100, height: 30)
                                        .modifier(CircleButton())

                                }
         
                                TextField("CODE", text: $code)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 130)

                                Button(action: {
                                                   veryfication()
                                }) {
                                    Text("verify")
                                        .padding()
                                        .frame(width: 100, height: 30)
                                        .modifier(CircleButton())

                                }
                            }
                            
                            }
                            .font(.system(size: 14))
                            .padding()
                            .offset(y: -50)

                    }
                          
                }
            }//geo
            
      
            
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("ok"), action: { self.alert.toggle()}))
        }
    }
    
    func notEmpty() -> Bool {
        if !self.name.isEmpty && self.name.count > 3 && !self.ccode.isEmpty && !self.no.isEmpty{
            return true
        }else{
            return false
        }
    }
    func authentication(){
        PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil) { (ID, err) in
            
            if err != nil {
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
            }
            self.ID = ID!
            self.isShow = true
        }
    }
    
    func veryfication(){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil {
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
            }
            guard let user =  res?.user else { return}
            let allData = AuthAll(authNumber: user.uid, authPhone: user.phoneNumber!, authName: name)
            
            do{
                let _ = try db.collection(user.uid).addDocument(from: allData)
         
            }catch{
                fatalError("unable to encoding task")
            }
            UserDefaults.standard.setValue(true, forKey: "status")
            NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
        }
    }
}
struct Adress_Previews: PreviewProvider {
    static var previews: some View {
        Adress()
    }
}


struct AuthAll : Codable, Identifiable , Hashable{

    var id         : String = UUID().uuidString
    var authNumber : String
    var authPhone  : String
    var authName   : String


}

struct CircleButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)

                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -8.0, y: -8.0) })

          //  .foregroundColor(.gray)
            .foregroundColor(.gray)
            .clipShape(  RoundedRectangle(cornerRadius: 7))
            .shadow(color: Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255), radius: 5, x: 5.0  , y:  5.0)
            .shadow(color: Color.white, radius: 50, x: -50.0 , y: -50.0)

    }
}
