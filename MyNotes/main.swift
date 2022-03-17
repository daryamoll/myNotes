//
//  main.swift
//  MyNotes
//
//  Created by Daria on 10.03.2022.
//

import Foundation

var myNotes = Notes()

myNotes.createFirstNote()
myNotes.createAllNotes()

print("Hello! You have \(myNotes.allNotes.count) note(s)")

var newAction = myNotes.requestAction()
while newAction != .close {
    switch newAction {
        case .add:
        myNotes.add()
    
        case .edit:
        myNotes.edit()
        
        case .delete:
        myNotes.delete()
        
        case .view:
        myNotes.view()
    
        default:
        break
    }
    newAction = myNotes.requestAction()
}
 
if newAction == .close {
    myNotes.closeApp()
}
