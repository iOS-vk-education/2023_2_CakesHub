//
//  SwiftDataTestView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 02.05.2024.
//

import SwiftUI
import SwiftData

@Model
final class Person {
    let name: String
    let age: String
    let job: Job
    let userName: String

    init(
        name: String,
        age: String,
        job: Job,
        userName: String
    ) {
        self.name = name
        self.age = age
        self.job = job
        self.userName = userName
    }
}

@Model
final class Job {
    let name: String
    let sallary: String

    init(name: String, sallary: String) {
        self.name = name
        self.sallary = sallary
    }
}

struct SwiftDataTestView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        Text("View").onAppear {
            let person = Person(
                name: "Dima Permyakov",
                age: "12",
                job: Job(
                    name: "developer",
                    sallary: "123_000"
                ),
                userName: "mightyK1ngRichard"
            )
            modelContext.insert(person)
            try? modelContext.save()
            print(person)
        }
    }
}

#Preview {
    SwiftDataTestView()
}
