# PreFixIt
A lightweight Swift CLI tool that automatically prefix your Git commit messages with the current branch name. This helps ensures your commit messages are consistent and descriptive, especially when working in teams or feature branches.

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

3. Move the executable to your PATH. This should allow you to run `PreFixIt` in your Terminal

```
cp .build/release/PreFixIt /usr/local/bin/PreFixIt
```

# Usage

To run `PreFixIt`:

```
swift run PreFixIt
``` 

or pass in `-v` to get helpful logs

```
swift run PreFixIt -v
```

# Recommended

Though not required, it would be helpful to run automated this tool as part of Git hook. This would allow the PreFixIt to run whenever you make a commit. Below are some helpful steps to guide you in your setup per repository:

1. Navigate to your repository:

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
exec PreFixIt
```

4. Save and exit to make the file executable:

```
chmod +x .git/hooks/prepare-commit-msg
```

`PreFixIt` should now automatically be able to prefix your commit messages in this repo with your current branch name.

# License

This project is licensed under the MIT License.

