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

        private var pathToRuby: String {
            ShellCommand.run("/usr/bin/env", ["which", "ruby"])?.trimmingCharacters(in: .newlines) ?? ""
        }

        private var pathToGem: String {
            ShellCommand.run("/usr/bin/env", ["which", "gem"])?.trimmingCharacters(in: .newlines) ?? ""
        }

        private var pathToBundler: String {
            ShellCommand.run("/usr/bin/env", ["which", "bundle"])?.trimmingCharacters(in: .newlines) ?? ""
        }
        
        func run() throws {

            let defaultTeamId = "4XJM4GSZPH"
            let defaultTeamName = "Sequenia"

            let projectName = ask("Enter project name", type: String.self)
            let bundleId = ask("Enter project bundle id", type: String.self)
            var debugBundleId = ask("Enter project debug bundle id ('\(bundleId)' by default)", type: String.self)
            let prefixYouTrack = ask("Enter prefix YouTrack", type: String.self)
            var teamId = ask("Enter your team id from Apple Developer Center ('\(defaultTeamId)' by default)", type: String.self)
            var companyName = ask("Enter your company name name ('\(defaultTeamName)' by default)", type: String.self)

            if debugBundleId.isEmpty {
                debugBundleId = bundleId
            }

            if companyName.isEmpty {
                companyName = defaultTeamId
            }
            
            if teamId.isEmpty {
                teamId = defaultTeamName
            }
            
            print("Generamba install..")

            if let path = ProcessInfo.processInfo.environment["path"] {
                ShellCommand.run("/usr/bin/env", ["cd", path])
            }

            self.generambaInstall(companyName: companyName)

            let tempUserName = ShellCommand.run("/usr/bin/whoami")
            guard let userName = tempUserName?.trimmingCharacters(in: .newlines) else { return }
            
            print("Generate project..")
            
            let arguments = ["exec",
                             "generamba",
                             "gen",
                             "\(projectName)",
                             "ProjectTemplate",
                             "--custom_parameters",
                             "debug_bundle_id:\(debugBundleId)",
                             "release_bundle_id:\(bundleId)",
                             "prefix_youTrack:\(prefixYouTrack)",
                             "team_id:\(teamId)"]

            let outputGeneramba = ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle", arguments)
            if let out = outputGeneramba { print("\(out)") }
            
            self.removeTempFiles()
        }
        
        private func generambaInstall(companyName: String) {
            ShellCommand.run(self.pathToGem, ["install", "bundler"])
            ShellCommand.run("/usr/bin/touch", ["Gemfile"])
            
            self.createScriptSh(url: URL(fileURLWithPath: "Gemfile"),
                                content: Constant.gemFileContent)

            self.createScriptSh(url: URL(fileURLWithPath: "Gemfile.lock"),
                                content: "")
            
            print(ShellCommand.run(self.pathToBundler, ["install"]))
            
            ShellCommand.run("/usr/bin/touch", ["Rambafile"])
            self.createScriptSh(url: URL(fileURLWithPath: "Rambafile"),
                                content: Constant.rambaFileContent(companyName: companyName))
            
            print("Template install..")
            
            let setupGeneramba = ShellCommand.run(self.pathToBundler,
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
        
        private func removeTempFiles() {
            ShellCommand.run("/bin/rm", ["Gemfile"])
            ShellCommand.run("/bin/rm", ["Rambafile"])
            ShellCommand.run("/bin/rm", ["Gemfile.lock"])
            ShellCommand.run("/bin/rm", ["-rf", "Templates"])
            
        }
    }
}

