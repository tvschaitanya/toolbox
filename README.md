# Toolbox

A collection of shell scripts for managing and maintaining a macOS development environment.

## Project Structure

```text
toolbox/
├── app_list.sh
├── brew_update.sh
├── aws_reset.sh
└── README.md
````

| File             | Description                                                                                  |
| ---------------- | -------------------------------------------------------------------------------------------- |
| `app_list.sh`    | Generates a JSON inventory of installed applications and development tools.                  |
| `brew_update.sh` | Updates Homebrew, upgrades packages, performs cleanup, and checks for known vulnerabilities. |
| `aws_reset.sh`   | Resets the local AWS CLI environment by removing credentials and configuration.              |

## Usage

```bash
./app_list.sh
./brew_update.sh
./aws_reset.sh
```

## Notes

* `app_list.sh` is intended for macOS.
* `brew_update.sh` requires Homebrew.
* **Caution:** `aws_reset.sh` resets your local AWS CLI environment. Review the script before running it.
