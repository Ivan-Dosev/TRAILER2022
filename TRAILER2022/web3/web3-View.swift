//
//  web3-View.swift
//  ESP-relay
//
//  Created by Dosi Dimitrov on 18.01.22.
//

import SwiftUI
import web3swift
import PromiseKit
import Combine
import CryptoKit

 var contract:ProjectContract?
 
 var web3:web3?
 var network:Network = .goerli 
 var wallet:Wallet?
 var password = "dakata_7b" // leave empty string for ganache

// 0xA4380435a13153C41658acC729B369Ddb84f5c11
struct ArdaView: View {

  //  let projectTitle = 776

    var body: some View {
        VStack{
           
            
            Button(action: {
       //     // Create wallet using either a private key or mnemonic
       //     wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"GanacheWallet")
       //     // Create contract with wallet as the sender
       //     contract = ProjectContract(wallet: wallet!)
       //     // Call contract method
       //    createNewProject()
            }) {
                HStack{
                    Text("↗️")
                    
                    Text("Deploy")
                }
                .padding()
                .font(.system(size: 24))
                .foregroundColor(.green)
        }



    }
  }
 //  func createNewProject() {
 //      let parameters = [projectTitle] as [AnyObject]
 //      firstly {
 //          // Call contract method
 //          callContractMethod(method: .projectContract, parameters: parameters,password: "dakata_7b")
 //      }.done { response in
 //          self.getProjectTitle()
 //      }
 //  }

 //  func getProjectTitle() {
 //      let parameters = [] as [AnyObject]
 //      firstly {
 //          callContractMethod(method: .getProjectTitle, parameters: parameters,password: nil)
 //      }.done { response in
 //          // print out response
 //          print("getProjectTitle response \(response)")
 //      }
 //  }
}
