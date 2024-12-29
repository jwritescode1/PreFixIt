#!/usr/bin/swift
import Foundation

@main
struct PreFixItTool {
    
    public func run() throws {
        guard let branchName = getBranchName() else {
            print("PreFixIt failed to get branch name. Please ensure branch name is setup")
            exit(1)
        }
        
        guard let commitMessage = readLine(), commitMessage.isEmpty else {
            print("PreFixIt needs a commit message. Currently commit message seems to be nil or empty")
            exit(1)
        }
        
        prefixCommitMessage(with: branchName, existingMessage: commitMessage)
    }
}

private extension PreFixItTool {
    
    func getBranchName() -> String? {
        return runShell("git rev-parse --abbrev-ref HEAD")
    }
    
    func prefixCommitMessage(with branchName: String, existingMessage: String) {
        let prefixMessage = "[\(branchName)] \(existingMessage)"
        let commitCommand = "git commit -m \"\(prefixMessage)\""
        
        if runShell(commitCommand) != nil {
            print("PreFixIt successfully update commit message")
        } else {
            print("Hmmm...sorry. PreFixIt failed to commit. Please ensure Git is working appropriately")
        }
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
