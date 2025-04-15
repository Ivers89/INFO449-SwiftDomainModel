import XCTest
@testable import DomainModel

class PersonTests: XCTestCase {

    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }

    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)

        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)

        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }

    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)

        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)

        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }
    
    func testNamelessPerson() { //Check that a person's name can't be empty otherwise set to "Default"
        let namelessPerson = Person(firstName: "", lastName: "", age:0)
        XCTAssertEqual(namelessPerson.firstName, "Default")
        XCTAssertEqual(namelessPerson.lastName, "Default")
      }
    
    func testNegativeAgeRevertsToPrevious() { //Don't let a person have their age changed to a negative value
        let person = Person(firstName: "Michael", lastName: "Jordan", age: 62)
        person.age = -5
        XCTAssertEqual(person.age, 62)
    }
    
    func testSelfMarriage() { //You can't love yourself that much
        let person = Person(firstName: "Solo", lastName: "Bolo", age: 30)
        person.spouse = person
        XCTAssertNil(person.spouse)
    }
    
    func testNegativeHourlyWage() {
        let person = Person(firstName: "Work", lastName: "Hard", age: 25)
        person.job = Job(title: "Unpaid work", type: .Hourly(-10.0))
        XCTAssertNil(person.job, "Job with negative hourly wage should be rejected")
    }
    
    

    static var allTests = [
        ("testPerson", testPerson),
        ("testAgeRestrictions", testAgeRestrictions),
        ("testAdultAgeRestrictions", testAdultAgeRestrictions),
        ("testNamelessPerson", testNamelessPerson),
        ("testNegativeAgeRevertsToPrevious", testNegativeAgeRevertsToPrevious),
        ("testSelfMarriage", testSelfMarriage),
        ("testNegativeHourlyWage", testNegativeHourlyWage)
    ]
}

class FamilyTests : XCTestCase {
  
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
    }

    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
    }
    
  
    static var allTests = [
        ("testFamily", testFamily),
        ("testFamilyWithKids", testFamilyWithKids),
    ]
}
