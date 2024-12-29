#!/usr/bin/swift
import Foundation

@main
struct PreFixItTool {
    
    public func run() throws {
        
    }
}

private extension PreFixItTool {
    
    func getBranchName() -> String? {
        return runShell("git rev-parse --abbrev-ref HEAD")
    }
    
    func runShell(_ command: String) -> String? {
        let process = Process()
        let pipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", command]
        
        // Use user's existing shell
        if let userShell = ProcessInfo.processInfo.environment["SHELL"] {
            process.executableURL = URL(fileURLWithPath: userShell)
        } else {
            process.executableURL = URL(fileURLWithPath: "/bin/sh")
        }
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return ("Command: \(command) encountered error. Error: \(error.localizedDescription)")
            exit(1)
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return output
        } else {
            print("Output is nil")
            exit(1)
        }
    }
}
