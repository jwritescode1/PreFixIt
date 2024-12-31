import Foundation
import ArgumentParser

@main
struct PreFixIt: ParsableCommand {

    @Flag(name: .short, help: "Display logs for debugging purposes")
    var verbose: Bool = false
    
    func run() throws {
        guard let branchName = getBranchName() else {
            print("PreFixIt failed to get branch name. Please ensure branch name is setup")
            return
        }
        
        guard let lastCommitMessage = getLastCommitMessage(), !lastCommitMessage.isEmpty else {
            print("PreFixIt needs a commit message. Currently commit message seems to be nil or empty")
            return
        }
        
        printProgressIfNeeded("PreFixIt updating last commit message")
        updateCommitMessage(with: branchName, existingMessage: lastCommitMessage)
    }
}

// MARK: - Private

private extension PreFixIt {
    
    func getBranchName() -> String? {
        printProgressIfNeeded("Getting current branch name")
        return runShell("git rev-parse --abbrev-ref HEAD")
    }
    
    func getLastCommitMessage() -> String? {
        printProgressIfNeeded("Getting last commit message")
        return runShell("git log -1 --pretty=%B")
    }
    
    func updateCommitMessage(with branchName: String, existingMessage: String) {
        guard !existingMessage.contains("[\(branchName)]") else {
            print("Skipping this commit as it already has branch name specified")
            return
        }
        
        let updatedCommitMessage = "[\(branchName)] \(existingMessage)"
        let commitCommand = "git commit --amend -m \"\(updatedCommitMessage)\" --no-edit"
        
        if runShell(commitCommand) != nil {
            printProgressIfNeeded("PreFixIt successfully update commit message to \(updatedCommitMessage)")
        } else {
            printProgressIfNeeded("Hmmm...sorry. PreFixIt failed to commit. Please ensure Git is working appropriately")
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
            print("Command: \(command) encountered error. Error: \(error.localizedDescription)")
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return output
        } else {
            print("Output is nil")
            return nil
        }
    }
    
    func printProgressIfNeeded(_ message: String) {
        guard verbose else { return }
        print(message)
    }
}
