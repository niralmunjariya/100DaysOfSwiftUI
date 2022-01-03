import Cocoa

// Day 15: Consolidation I: Review of Swift Programming Language


// Variables
var greeting = "Hello"
// Constant variable
let name = "Niral"


// String - It start and end with " (double quotes), it can include emojis
let actor = "Tom Cruise 🧗‍♂️"
// String with quotes
let quote = "He tapped a sign saying \"Believe\" and waked away."
// Multi line string
let movie = """
A day in
the life of an
Apple engineer
"""

// Integers
let score: Int = 10
let higherScore = score + 10
let halvedScore = score / 2
var counter = 10
counter += 5
let number = 120

// Doubles - Integer and Double are different data types in Swift and they cannot be mixed
let rating: Double = 10.0

// Boolean
let goodDogs: Bool = true
let gameOver = false
var isSaved = false
isSaved.toggle()

// String Interpolation
let user = "Taylor"
let age = 26
let message = "I'm \(user) and I'm \(age) years old."
print(message);


// Arrays
var colors = ["Red", "Green", "Blue"]
var numbers = [4, 8, 15]
var readings = [0.1, 0.5, 0.8]
print(colors[0])
print(readings[2])
colors.append("Purple")
colors.remove(at: 0)
print(colors.count);
 
