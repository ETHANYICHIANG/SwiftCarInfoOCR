import UIKit

class VotingManager {
    
    // For every character slot in the license plate number, we are keeping track of how many times the OCR model predicts a particular character to be in that slot. For example, if we added strings "abc" and "acd" to the characterFrequencies array, we would get an object like:
    /*
characterFrequencies = [
            {
                'a': 2
            },
            {
                'b': 1,
                'c': 1
            },
            {
                'c': 1,
                'd': 1
            },
        ]
    */
    private var characterFrequencies: [[Character:Int]] = []

    func add(licensePlate: String) {
        // If characterFrequencies hasn't been initialized, use this first licensePlate to initialize it.
        if characterFrequencies == [] {
            for character in licensePlate {
                characterFrequencies.append([character:1])
            }
        
        // If characterFrequencies has had at least one license plate entered into it, then add characters from new license plate number into existing character slots
        } else {
            for (index, character) in licensePlate.enumerated() {
                characterFrequencies[index][character] = (characterFrequencies[index][character] ?? 0) + 1
            }
        }
    }
    
    func chooseMostLikelyLicensePlate() -> String {
        
        func findMostFrequentCharacter(characterSlot: [Character:Int]) -> Character {
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
        var licensePlate = ""
        for characterSlot in characterFrequencies {
            let mostFrequentCharacter = findMostFrequentCharacter(characterSlot: characterSlot)
            licensePlate += String(mostFrequentCharacter)
        }
        return licensePlate
    }
    
    func clear() {
        characterFrequencies = []
    }

}

func testVotingManger() {
    let votingManager = VotingManager()
    votingManager.add(licensePlate: "7a77777")
    votingManager.add(licensePlate: "7a77776")
    votingManager.add(licensePlate: "7777766")
    print(votingManager.chooseMostLikelyLicensePlate())
}

testVotingManger()
