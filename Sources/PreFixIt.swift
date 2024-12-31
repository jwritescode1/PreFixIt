import Foundation
import ArgumentParser

@main
struct PreFixIt: ParsableCommand {

    @Flag(name: .short, help: "Display logs for debugging purposes")
    var verbose: Bool = false
    
    func run() throws {
        printProgressIfNeeded("PreFixIt running...")
        
        guard let branchName = getBranchName() else {
            print("PreFixIt was not able to retrieve branch name")
            return
        }
        
        guard CommandLine.arguments.count > 1 else {
            print("PreFixIt failed. There was no commit message file path provided")
            return
        }
        
        printProgressIfNeeded("PreFixIt searching for commit message file path")
        
        let commitMessageFilePath = CommandLine.arguments[1]
        guard let currentMessage = try? String(contentsOfFile: commitMessageFilePath, encoding: .utf8) else {
            print("PreFixIt failed. Unable to read the commit message from the file")
            return
        }

        guard !currentMessage.contains("[\(branchName)]") else {
            printProgressIfNeeded("No update required for commit message as it already contains [\(branchName)]")
            return
        }
        
        printProgressIfNeeded("PreFixIt successfully encoded commit message")
        
        do {
            printProgressIfNeeded("PreFixIt updating commit message")
            let updatedMessage = "[\(branchName)] \(currentMessage)"
            try updatedMessage.write(toFile: commitMessageFilePath, atomically: true, encoding: .utf8)
            print("PreFixIt successfully updated the commit message to: \(updatedMessage)")
        } catch {
            print("PreFixIt failed. Unable to write commit to file. Error: \(error.localizedDescription)")
        }
    
    }
}

// MARK: - Private

private extension PreFixIt {
    
    func getBranchName() -> String? {
        printProgressIfNeeded("Getting current branch name")
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
