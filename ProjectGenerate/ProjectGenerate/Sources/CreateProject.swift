//
//  CreateProject.swift
//  ProjectGenerate
//
//  Created by Ivan Mikhailovskii on 22.04.2021.
//

import Foundation
import ArgumentParser
import Swiftline
import ShellOut

extension ProjectGenerateCommand {
    
    struct CreateProject: ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "gen",
            abstract: "Project generate start..",
            discussion: "discussion")
        
        func run() throws {

            let projectName = ask("Enter project name", type: String.self)
            let debugBundleId = ask("Enter project debug bundle id", type: String.self)
            let releaseBundleId = ask("Enter project release bundle id", type: String.self)

            print("\nGeneramba install..\n")
            self.generambaInstall()

            let tempUserName = ShellCommand.run("/usr/bin/whoami")
            guard let userName = tempUserName?.trimmingCharacters(in: .newlines) else { return }

            let arguments = ["exec",
                             "generamba",
                             "gen",
                             "\(projectName)",
                             "ProjectTemplate",
                             "--custom_parameters",
                             "debug_bundle_id:\(debugBundleId)",
                             "release_bundle_id:\(releaseBundleId)"]

            let outputGeneramba = ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle", arguments)
            if let out = outputGeneramba { print("\(out)") }
        }
        
        private func generambaInstall() {
            let tempUserName = ShellCommand.run("/usr/bin/whoami")
            guard let userName = tempUserName?.trimmingCharacters(in: .newlines) else { return }
            
            ShellCommand.run("/Users/\(userName)/.rbenv/shims/gem", ["install", "bundler"])
            ShellCommand.run("/usr/bin/touch", ["Gemfile"])
            ShellCommand.run("/bin/chmod", ["+x", "Gemfile"])
            
            self.createScriptSh(url: URL(fileURLWithPath: "Gemfile"),
                                content: Constant.contentGemFile)
            
            ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle", ["install"])
            
            ShellCommand.run("/usr/bin/touch", ["Rambafile"])
            self.createScriptSh(url: URL(fileURLWithPath: "Rambafile"),
                                content: Constant.rambaFileContent)
            
            print("\nTemplate install..\n")
            
            let setupGeneramba = ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle",
                                                  ["exec", "generamba", "template", "install"])
            
            guard let outSetupGeneramba = setupGeneramba else  {
                print("rambafile not found")
                return
            }
            print(outSetupGeneramba)
        }
        
        private func createScriptSh(url: URL?, content: String) {
            guard let url = url else { return }
            try? content.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
