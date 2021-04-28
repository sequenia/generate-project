//
//  main.swift
//  ProjectGenerate
//
//  Created by Ivan Mikhailovskii on 22.04.2021.
//

import Foundation
import ArgumentParser

struct ProjectGenerateCommand: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "Create Project gen",
        abstract: "progect generate",
        discussion: "",
        subcommands: [
            CreateProject.self
        ],
        defaultSubcommand: CreateProject.self
    )
}

ProjectGenerateCommand.main()

