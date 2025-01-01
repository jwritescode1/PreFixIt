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

# Usage

**PreFixIt** was designed in my mind to work along side with Git hook. This would allow the PreFixIt to run whenever you make a commit automatically. To setup per repository:

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

4. Save and exit:

4a. Ctrl + O

4b. Enter

4c. Ctrl + X

5. Provide permission to ensure the file is executable:

```
chmod +x .git/hooks/prepare-commit-msg
```

**PreFixIt** should now automatically be able to prefix your commit messages with your current branch name.

# License

This project is licensed under the MIT License.

