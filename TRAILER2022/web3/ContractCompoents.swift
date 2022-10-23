// works 2
//  ContractCompoents.swift
//  web3Interaction
//
//  Created by Mitchell Tucker on 5/14/21.
//works2

import Foundation

// Methods available within the contract
enum ContractMethods:  String {

    case projectContract = "store"
    case getProjectTitle = "retrieve"
}

var contractAddress = "0x8f4B65557906e4C20970B8aC11fe728C7E140991"

let contractABI =
     """
 [{"inputs":[],"name":"retrieve","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"num","type":"string"}],"name":"store","outputs":[],"stateMutability":"nonpayable","type":"function"}]

 """


