# Toolbox

A collection of shell scripts for managing and maintaining a macOS development environment.

## Included Scripts

### `app_list.sh`

Generates a JSON inventory of installed software on your Mac.

#### Detects

* Mac App Store applications
* Homebrew formulae
* Homebrew casks
* Manually installed applications
* Development tools, including:

  * Oh My Zsh
  * NVM
  * Node.js
  * pyenv
  * rbenv
  * and others

#### Output

Creates a file in the current directory:

```text
Apps_List_YYYYMMDD.json
```

#### Run

```bash
./app_list.sh
```

---

### `brew_update.sh`

Performs routine Homebrew maintenance.

#### Actions

* Updates Homebrew
* Upgrades installed formulae
* Upgrades installed casks
* Removes outdated package versions (`brew cleanup`)
* Scans installed packages for known vulnerabilities (`brew vuln`)
* Lists packages that depend on vulnerable software

#### Requirements

* Homebrew

#### Run

```bash
./brew_update.sh
```

---

### `aws_reset.sh`

Removes local AWS CLI credentials and configuration.

#### Actions

* Deletes `~/.aws`
* Removes the AWS CLI cache
* Removes the AWS CLI history file
* Unsets AWS-related environment variables for the current shell
* Removes AWS-related configuration from:

  * `~/.zshrc`
  * `~/.bash_profile`
  * `~/.bashrc`
  * `~/.profile`

The script prompts for confirmation before making any changes.

#### Run

```bash
./aws_reset.sh
```

Reload your shell after running:

```bash
source ~/.zshrc
```

Or simply open a new terminal session.

---

## Requirements

| Requirement | Used By                          |
| ----------- | -------------------------------- |
| macOS       | All scripts                      |
| Zsh         | `app_list.sh`                    |
| Bash        | `brew_update.sh`, `aws_reset.sh` |
| Homebrew    | `app_list.sh`, `brew_update.sh`  |

---

## Installation

```bash
git clone https://github.com/yourusername/toolbox.git
cd toolbox

chmod +x app_list.sh brew_update.sh aws_reset.sh
```

---

## Project Structure

```text
toolbox/
├── app_list.sh
├── brew_update.sh
├── aws_reset.sh
└── README.md
```

---

## Notes

* `app_list.sh` uses `mdls` and scans `/Applications`, so it is intended for macOS.
* `aws_reset.sh` permanently removes local AWS CLI credentials and configuration. Back up `~/.aws` before running if you want to preserve existing profiles or credentials.
