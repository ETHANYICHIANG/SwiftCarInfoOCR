//
//  LicensePlateTextAnalyzer.swift
//  SwiftCarInfoOCR
//
//  Created by Elias Heffan on 3/11/20.
//  Copyright © 2020 EYC. All rights reserved.
//

import Foundation

class LicensePlateTextAnalyzer {

    private var likelyLicensePlateNumbers: [String]  = []
    
    func add(potentialLicensePlateNumber: String) {
        if (isLikelyLicensePlateNumber(potentialLicensePlateNumber)) {
            likelyLicensePlateNumbers.append(potentialLicensePlateNumber)
        }
    }
    
    /// Returns most likely license plate number, or nil if either:
    ///     No potential license plate numbers were added, OR
    ///     All potential license plate numbers were deemed unlikely to be a license plate number.
    func determineMostLikelyLicensePlateNumber() -> String? {
        // Check if there are no likely license plate numbers
        if likelyLicensePlateNumbers == [] {
            return nil
        }
                
        // Initialize length of characterFrequencies to the most frequent length of all strings in likelyLicensePlateNumbers
        let lengthToAnalyze = mostFrequentLength(strings: likelyLicensePlateNumbers)
        let licensePlateNumbersToAnalyze = likelyLicensePlateNumbers.filter { $0.count == lengthToAnalyze}
        var characterFrequencies: [[Character:Int]] = Array(repeating: [:], count: lengthToAnalyze)
            // NOTE: For every character slot in the license plate number, we are keeping track of how many times the OCR model predicts a particular character to be in that slot. For example, if we added strings "abc" and "acd" to the characterFrequencies array, we would get an object like:
            /*
                characterFrequencies = [
                    { // Character Slot 1
                        'a': 2
                    },
                    { // Character Slot 2
                        'b': 1,
                        'c': 1
                    },
                    { // Character Slot 3
                        'c': 1,
                        'd': 1
                    },
                ]
            */


        // Add characters from all likely license plate numbers into character slots, keeping track of the frequency of each character that we've found in the slot so far.
        for licensePlateNumber in licensePlateNumbersToAnalyze {
            for (index, character) in licensePlateNumber.enumerated() {
                characterFrequencies[index][character] = (characterFrequencies[index][character] ?? 0) + 1
            }
        }
        

        // Finally, determine most likely license plate number by choosing most frequent character in each character slot.
        var licensePlateNumber = ""
        for characterSlot in characterFrequencies {
            let mostFrequentCharacter = findMostFrequentCharacter(characterSlot: characterSlot)
            licensePlateNumber += String(mostFrequentCharacter)
        }
        return licensePlateNumber
    }
    
    func clearAddedNumbers() {
        likelyLicensePlateNumbers = []
    }
        
    private func isLikelyLicensePlateNumber(_ text: String) -> Bool {
        /* Almost all License Plate Numbers are between 4 and 8 characters */
        if text.count < 4 || text.count > 8 {
            return false
        }
        
        /* Almost all License Plate Numbers only contain letters, numbers, and whitespace */
        for char in text {
            if !char.isUppercase && !char.isNumber && !char.isWhitespace {
                return false
            }
        }
        
        /* Almost all License Plate Numbers contain at least one letter and one number */
        var foundLetter = false
        var foundNumber = false
        for char in text {
            if char.isLetter {
                foundLetter = true
            } else if char.isNumber {
                foundNumber = true
            }
        }
        if (!foundLetter || !foundNumber) {
            return false
        }
                
        /* Passed all tests! */
        return true
    }
    
    private func mostFrequentLength(strings: [String]) -> Int {
        /* For keeping track of the frequency of every length string found in `strings` array */
        var stringLengthFrequencies: [Int:Int] = [:]
        
        /* Determine the frequencies of every string length in `strings` array */
        for number in likelyLicensePlateNumbers {
            stringLengthFrequencies[number.count] = (stringLengthFrequencies[number.count] ?? 0) + 1
        }
        
        /* Find the most frequent string length in stringLengthFrequencies */
        let stringLengthFrequencyPair = stringLengthFrequencies.max { lengthFrequencyPair1, lengthFrequencyPair2  in
            lengthFrequencyPair1.value < lengthFrequencyPair2.value
        }
        return stringLengthFrequencyPair?.key ?? 0
    }
    
    private func findMostFrequentCharacter(characterSlot: [Character:Int]) -> Character {
        var mostFrequentCharacter = Character("a") //random starting character
        var frequencyOfMostFrequentCharacter = 0
        
        for (character, frequency) in characterSlot {
            if frequency > frequencyOfMostFrequentCharacter {
                mostFrequentCharacter = character
                frequencyOfMostFrequentCharacter = frequency
            }
        }
        
        return mostFrequentCharacter
    }

    func simpleTest() {
        add(potentialLicensePlateNumber: "7A77777")
        add(potentialLicensePlateNumber: "7A77776")
        add(potentialLicensePlateNumber: "B777766")
        if let licensePlateNumber = determineMostLikelyLicensePlateNumber() {
            print(licensePlateNumber)
        }
        clearAddedNumbers()
    }

    func complexTest() {
        
        let car1 = ["DEC", "DE", "DC", "EC", "D", "C", "E", "Californig", "Californiy", "Californir", "Californi", "Colifornig", "Californg", "Coliforniy", "Colifornir", "Coliforni", "Californy", "2018", "018", "218", "208", "201", "18", "08", "01", "28", "21", "7NXT881", "ZVXT881", "ZNXT881", "7NXT88 1", "ZVXT88 1", "ZNXT88 1", "2NXT881", "7VXT881", "7VXT88 1", "2NXT88 1", "v.ca.gov", ".ca.gov", "y.ca.gov", "vca.gov", "v.a.gov", "v.cagov", "v.c.gov", "ca.gov", "v.ca.gv", "yca.gov"]
        let car2 = ["32", "3E", "3", "2", "#", "NEW YORK®", "NEW YORK", "NEW YORK°", "NEW YORK•", "NEW YORKO", "NEW YOK®", "EW YORK®", "NEW YOK°", "NEW YOK•", "NEW ORK®", "MRSNOOPY", "WRSNOOPY", "NRSNOOPY", "EMPIRE STATE -", "EMPIRE STATE .", "EMPIRE STATE •", "EMPIRE STATE-", "EMPIRE STATE.", "EMPIRE STATE", "EMPIRE STATE•", "EMPIE STATE -"]
        let car3 = ["NEW YORK", "NEW YORK\"", "NEW YORK~", "NEW YORK -", "NEW YORK \"", "NEW YORKTM", "NEW YORK'", "NEW YORK ~", "FXD4177i", "FXD+177i", "FX04177i", "FX0+177i", "FXD4177", "FXD+177", "FX04177", "FX0+177", "FXD177i", "FX0177i", "EMPIRE STATE", "EMPIRE STATE o", "EMPIRE STATE S", "EMPIRE STATE s", "EMPIRE STATE 5", "EMPIRE STATE O", "EMPIRE STATE 6", "EMPIRE STATE 3", "EMPIRE STATES"]
        let car4 = ["DRIVER CARRIES NO CASH", "DRIVER CARRIES NOCASH", "DRIVER CARIES NO CASH", "DRIVER CARRIES O CASH", "RIVER CARRIES NO CASH", "DRIVER CARRIES N CASH", "DRIVER CARRIES NO ASH", "DRIVER CARRIESNO CASH", "DRIVER CARRIES NO CAH", "DRIVER CARRIES NO CAS", "MAR", "MA", "AR", "MR", "A", "M", "R", "ALIFORNIA", "ALIFORNIO", "ALIFORNI", "ALIFORNA", "ALIFORNO", "ALFORNIA", "ALIFONIA", "ALFORNIO", "ALIFONIO", "ALIFORIA", "2016", "216", "016", "206", "201", "16", "26", "21", "06", "01", "12211110", "12211410", "02211110", "122111110", "12211111", "02211410", "122114110", "022111110", "12211411", "12211117", "JXN 6L6", "JXN 6L6.", "LJXN 6L6", "JXN 6L 6", "LJXN 6L6.", "JXN 6L 6.", "MY DAUGHTER GETTING MARRIED", "Y DAUGHTER GETTING MARRIED", "MY DAUGHTER GETTING MARIED", "MY DAUGHTER GETTING MARRED", "MY DAUGHTER GETING MARRIED", "MY DAUGHTERGETTING MARRIED", "MY DAUGHTER GETTING MARRID", "MY DAUGHTER GETTING ARRIED", "MY DAUGHTR GETTING MARRIED", "MY DAGHTER GETTING MARRIED", "IL MA OYORILL", "IL MA OYORHLL", "IL MA OYORILLL", "ILMA OYORHLL", "IL MA OYOBILL", "IL MA OYORHLLL", "IL MA JOYORILL", "IL MA OYOBHLL", "IL MA JOYORHLL", "IL MA JOYOBHLL"]

        let cars = [car1, car2, car3, car4]
        
        for car in cars {
            for string in car {
                add(potentialLicensePlateNumber: string)
            }
            if let licensePlateNumber = determineMostLikelyLicensePlateNumber() {
                print(licensePlateNumber)
            } else {
                print("Could not determine a possible license plate")
            }
            clearAddedNumbers()
        }
    }
}
