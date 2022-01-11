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

import Constant
import Utils

extension ProjectGenerateCommand {
    
    struct CreateProject: ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "gen",
            abstract: "Project generate start..",
            discussion: "discussion"
        )
        
        func run() throws {
            let defaultTeamId = "4XJM4GSZPH"
            let defaultTeamName = "Sequenia"
            let defaultMinPlatformVersion = "14.0"
            let defaultLangCode = "en"

            let projectName = ask("Enter project name", type: String.self)

            let bundleId = ask("Enter project bundle id", type: String.self)

            var langCode = ask("Enter language ISO code ('\(defaultLangCode)' by default)", type: String.self)
            if langCode.isEmpty {
                langCode = defaultLangCode
            }
            var fastlaneLangCode = langCode.replacingOccurrences(of: "_", with: "-")
            let codesMap = [
                "en": "en-US",
                "de": "de-DE",
                "fr": "fr-FR",
                "es": "es-ES"
            ]
            if let code = codesMap[fastlaneLangCode] {
                fastlaneLangCode = code
            }

            var minPlatformVersion = ask("Enter minimum supported iOS version ('\(defaultMinPlatformVersion)' by default)", type: String.self)
            if minPlatformVersion.isEmpty {
                minPlatformVersion = defaultMinPlatformVersion
            }
            if !minPlatformVersion.contains(".") {
                minPlatformVersion = "\(minPlatformVersion).0"
            }

            var teamId = ask("Enter your team id from Apple Developer Center ('\(defaultTeamId)' by default)", type: String.self)
            if teamId.isEmpty {
                teamId = defaultTeamId
            }

            var companyName = ask("Enter your company name name ('\(defaultTeamName)' by default)", type: String.self)
            if companyName.isEmpty {
                companyName = defaultTeamName
            }
            
            print("Generamba install..")
            
            self.generambaInstall(companyName: companyName)

            let tempUserName = ShellCommand.run("/usr/bin/whoami")
            guard let userName = tempUserName?.trimmingCharacters(in: .newlines) else { return }
            
            print("Generate project..")
            
            let arguments = [
                "exec",
                "generamba",
                "gen",
                "\(projectName)",
                "ProjectTemplate",
                "--custom_parameters",
                "bundle_id:\(bundleId)",
                "lang_code:\(langCode)",
                "fastlane_lang_code:\(fastlaneLangCode)",
                "min_platform_version:\(minPlatformVersion)",
                "team_id:\(teamId)",
                "company_name:\(companyName)"
            ]

            let outputGeneramba = ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle", arguments)
            if let out = outputGeneramba { print("\(out)") }

            ShellCommand.run("/bin/chmod", ["-R", "+x", "\(projectName)/Project/RunScripts"])
            
            self.removeTempFiles()
        }
        
        private func generambaInstall(companyName: String) {
            let tempUserName = ShellCommand.run("/usr/bin/whoami")
            guard let userName = tempUserName?.trimmingCharacters(in: .newlines) else { return }
            
            ShellCommand.run("/Users/\(userName)/.rbenv/shims/gem", ["install", "bundler"])
            
            ShellCommand.run("/usr/bin/touch", ["Gemfile"])
            ShellCommand.run("/bin/chmod", ["+x", "Gemfile"])
            
            self.createScriptSh(url: URL(fileURLWithPath: "Gemfile"),
                                content: Constant.gemFileContent)
            
            ShellCommand.run("/Users/\(userName)/.rbenv/shims/bundle", ["install"])
            
            ShellCommand.run("/usr/bin/touch", ["Rambafile"])
            self.createScriptSh(url: URL(fileURLWithPath: "Rambafile"),
                                content: Constant.rambaFileContent(companyName: companyName))
            
            print("Template install..")
            
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
        
        private func removeTempFiles() {
            ShellCommand.run("/bin/rm", ["Gemfile"])
            ShellCommand.run("/bin/rm", ["Rambafile"])
            ShellCommand.run("/bin/rm", ["Gemfile.lock"])
            ShellCommand.run("/bin/rm", ["-rf", "Templates"])
            
        }
    }
}
