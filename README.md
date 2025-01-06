# PreFixIt
A lightweight Swift-based CLI tool that automatically prefixes your Git commit messages with the current branch name. This ensures better traceability of commits by associating them with their respective branches.


# Installation

1. Clone repository:

```
git clone https://github.com/jwritescode1/PreFixIt
cd PreFixIt
```

2. Build the executable:

```
swift build -c release
```

3. Copy the executable to your PATH. This should allow you to run `PreFixIt` in your Terminal

```
cp .build/release/PreFixIt /usr/local/bin/PreFixIt
```

# Git Hook setup

**PreFixIt** was designed in mind to work with Git hook. This would allow the PreFixIt to run whenever you make a commit automatically. You can either set the steps below in your centralised git hook or per repository. For simplicity, below are the steps required to setup per repository:

1. Navigate to your project repository:

```
cd /path/to/your/git/repository
```

2. Setup prepare-commit-message:

```
nano .git/hooks/prepare-commit-msg
```

3. Add the following content:

```
#!/bin/sh
exec PreFixIt "$1"
```

If you prefer to see the logs when PreFixIt gets to work, add the following content instead:

```
#!/bin/sh
exec PreFixIt -v "$1"
```

4. Save and exit by `Ctrl + O, Enter, Ctrl + X`

5. Provide permission to ensure the file is executable:

```
chmod +x .git/hooks/prepare-commit-msg
```

Once the setup is done, you should be able to commit as per normal and **PreFixIt** would automatically be able to prefix your commit messages with your current branch name. 

https://github.com/user-attachments/assets/49564925-6d1b-4a83-a12c-3f2887fb8a48





