//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class Car {
    
    var name = ""
    
    init(name: String) {
        self.name = name
    }
}

var car_1 = Car(name: "A")
var car_2 = Car(name: "B")
var car_3 = Car(name: "C")
var car_4 = Car(name: "D")

var cars = [
    car_1,
    car_2,
    car_3,
    car_4,
]

var newCars = cars
newCars.remove(at: 2)


print(cars.count)
for car in cars {
    print("car = \(car.name)")
}

for newcar in newCars {
    print("newcar = \(newcar.name)")
}