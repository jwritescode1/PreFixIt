import Foundation

@main
struct PreFixItTool {
    
    static func main() throws {
        do {
            try PreFixItTool().run()
        } catch {
            print("Unable to run PreFixIt. \(error.localizedDescription)")
            exit(1)
        }
    }
    
    func run() throws {
        guard let branchName = getBranchName() else {
            print("PreFixIt failed to get branch name. Please ensure branch name is setup")
            exit(1)
        }
        
        guard let lastCommitMessage = getLastCommitMessage(), !lastCommitMessage.isEmpty else {
            print("PreFixIt needs a commit message. Currently commit message seems to be nil or empty")
            exit(1)
        }
        
        if lastCommitMessage.contains("[\(branchName)]") {
            print("No task to be done by PreFixIt, commit message already is prefixed with current branch name")
            return
        } else {
            print("PreFixIt updating commit message")
            updateCommitMessage(with: branchName, existingMessage: lastCommitMessage)
        }
    }
}

private extension PreFixItTool {
    
    func getBranchName() -> String? {
        print("Getting current branch name")
        return runShell("git rev-parse --abbrev-ref HEAD")
    }
    
    func getLastCommitMessage() -> String? {
        print("Getting last commit message")
        return runShell("git log -1 --pretty=%B")
    }
    
    func updateCommitMessage(with branchName: String, existingMessage: String) {
        let updatedCommitMessage = "[\(branchName)] \(existingMessage)"
        let commitCommand = "git commit --amend -m \"\(updatedCommitMessage)\""
        
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
            print("Command: \(command) encountered error. Error: \(error.localizedDescription)")
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
