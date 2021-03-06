//
//  ShellCommand.swift
//  ProjectGenerate
//
//  Created by Ivan Mikhailovskii on 23.04.2021.
//

import Foundation

public class ShellCommand {
    
    @discardableResult
    public class func run(_ launchPath: String, _ arguments: [String] = []) -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: launchPath)
        task.arguments = arguments
        task.waitUntilExit()
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        return output
    }
}
