//
//  notes.swift
//  MyNotes
//
//  Created by Daria on 10.03.2022.
//

import Foundation

class Statuses {
    let error = "\u{1F534}"
    let action = "\u{1F539}"
    let ok = "\u{1F7E2}"
}

class Notes {
    var allNotes: [Note] = []
    let projectStatuses = Statuses()
    
    enum Actions: Int {
        case add = 1
        case edit
        case delete
        case view
        case close
    }
    
    //REQUEST AN ACTION FROM USER
    func requestAction () -> Actions {
        var input: String?
        var inputNumber: Int?
        print("""
        \nWhat do you want to do?
        1 - Add a new note
        2 - Edit note
        3 - Delete note
        4 - View all my notes
        5 - Save notes and close app
        """)
        input = readLine()
        inputNumber = Int(input!)
        
        if let action = inputNumber {
            if Actions(rawValue: action) != nil {
                return Actions.init(rawValue: inputNumber!)!
            } else {
                print("\(projectStatuses.error) Wrong number. Please enter a number from the list \(projectStatuses.error)")
                
                return requestAction()
            }
        } else {
            print("\(projectStatuses.error) Wrong number. Please enter a number from the list \(projectStatuses.error)")
            
            return requestAction()
        }
    }

    //CHECK FOR Int
    func isInt (_ readLineContent: String?) -> Bool {
        var intValue: Int?
        intValue = Int(readLineContent!)
        
        if intValue != nil {
            return true
        }
        
        return false
    }
    
    //ADDING A NOTE
    func add () {
        var name: String? = ""
        print("\n\(projectStatuses.action) Enter a title for your note \(projectStatuses.action)")
        
        name = readLine()
        if name == nil {
            name = "No name"
        }

        print("\n\(projectStatuses.action) Enter a content of your note. Finish by entering /q  \(projectStatuses.action)")
        
        var content: String = ""
        
        while let line = readLine(strippingNewline: true) {
            if line.hasSuffix("/q") {
                content.append(String(line.dropLast(1)))
                break
            }
            content.append(line)
            content.append("\n")
        }
        content.popLast()
        let note = Note(name: name!, content: content)
        allNotes.append(note)
    }
    
    //DELETING A NOTE
    func delete () {
        printListOfNotes()
        if allNotes.count > 0 {
            print("\n \(projectStatuses.action) What note do you want to delete? Please enter a number of this note \(projectStatuses.action)")
            
            var enteredValue: String?
            enteredValue = readLine()
            
            if isInt(enteredValue) {
                let enteredNumber = Int(enteredValue!)!
                if enteredNumber <= allNotes.count && enteredNumber > 0 {
                    allNotes.remove(at: enteredNumber - 1)
                    print("\(projectStatuses.ok) Note #\(enteredNumber) deleted successfully \(projectStatuses.ok)")
                } else {
                    print("\(projectStatuses.error) There is no note with this number. Please enter a number from the list \(projectStatuses.error)")
                    delete()
                }
            } else {
                print("\(projectStatuses.error) This is not a number. Please enter a number from the list \(projectStatuses.error)")
                delete()
            }
        } else {
            return
        }
    }
        
    //EDITING A NOTE
    func edit () {
        printListOfNotes()
        print(" \(projectStatuses.action) Please enter the note number you want to edit \(projectStatuses.action)")
        var enteredValue: String?
        enteredValue = readLine()
        var newContent: String = ""
        
        if isInt(enteredValue) {
            let enteredNumber = Int(enteredValue!)!
            if enteredNumber <= allNotes.count && enteredNumber > 0 {
                print("Content of this note:\n\(allNotes[enteredNumber-1].content)")
                print("\n \(projectStatuses.action) Enter a new content of the note <\(allNotes[enteredNumber-1].name)>. Finish by entering /q \(projectStatuses.action)")
                while let line = readLine(strippingNewline: true) {
                    if line.hasSuffix("/q") {
                        newContent.append(String(line.dropLast(1)))
                        break
                    }
                    newContent.append(line)
                    newContent.append("\n")
                }
            } else {
                print("\(projectStatuses.error) Note with this number doesn't exist. Please try again \(projectStatuses.error)")
                edit()
            }
        } else {
            print("\(projectStatuses.error) This is not a number. Please enter a number from the list \(projectStatuses.error)")
            edit()
        }
    }
        
    
    //DISPLAY LIST OF NOTES
    func printListOfNotes () {
        if allNotes.isEmpty {
            print("\(projectStatuses.error) You don't have any notes \(projectStatuses.error)")
        } else {
            print("\n \(projectStatuses.action) Here is a list of your notes \(projectStatuses.action)")
            
            for element in 0...allNotes.count-1 {
                print("\(element+1).\(allNotes[element].name)")
            }
        }
    }
    
    //VIEWING NOTES AND THEIR CONTENT
    func view () {
        printListOfNotes()
        print("\(projectStatuses.action) If you want to check a content of some note, please enter a number of this note. Otherwise please enter <no> \(projectStatuses.action)")
        var answer: String?
        answer = readLine()
        var enteredNumber: Int
        
        if answer != nil {
            if isInt(answer) {
                enteredNumber = Int(answer!)!
                if enteredNumber <= allNotes.count && enteredNumber > 0{
                print(allNotes[enteredNumber - 1].content)
                } else {
                    print("\(projectStatuses.error) Note with this number doesn't exist. Please try again \(projectStatuses.error)")
                    view()
                }
            } else if answer == "no" {
                return
            } else {
                print("\(projectStatuses.error) Sorry, I don't understand you :( Please print a number of a note or print <no> \(projectStatuses.error)")
                view()
            }
        } else {
            print("\(projectStatuses.error) Sorry, I don't understand you :( Please print a number of a note or print <no>")
            view()
        }
    }

    
    // CREATING first_note FILE WITH A NOTE FOR THE FIRST LAUNCH
    func createFirstNote () {
        let fileName = "first_note.txt"
        let text: String = "@My first note@Hello, world!"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(fileName)
            
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch { print("Writing error") }
        }
    }
    
    //CREATING notes.txt FILE TO SAVE NOTES
    func saveFile (_ file: String) {
        var text: String = ""
        for element in myNotes.allNotes {
            text.append("@\(element.name)@")
            text.append("\(element.content)")
            text.append("\n")
        }

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let path = dir.appendingPathComponent(file)
            
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch { print("Writing error") }
        }
    }
    
    // CREATING A LIST OF NOTES FROM THE FILE
    func createAllNotes () {
        var fileName = "notes.txt"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                fileName = "first_note.txt"
            }
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(fileName)
            do {
                let text = try String(contentsOf: path, encoding: String.Encoding.utf8)
                
                if text == "" {
                    allNotes = []
                    return
                }
                
                let partsOfNotes = text.split(separator: "@")
                let names = partsOfNotes.filter {partsOfNotes.firstIndex(of: $0)! % 2 == 0 }
                let contents = partsOfNotes.filter {partsOfNotes.firstIndex(of: $0)! % 2 == 1 }

                for index in 0...names.count - 1 {
                    allNotes.append(Note(name: String(names[index]), content: String(contents[index])))
                }
            }
            catch { print("Reading error") }
        }
    }
    
    //CLOSING THE APP
    func closeApp () {
        myNotes.saveFile("notes.txt")
        print("\(projectStatuses.ok) All your notes are saved. See you soon! :) \(projectStatuses.ok)")
    }
}
