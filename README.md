# hostupd - Hosts File Updater Script

![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)

`hostupd` is a simple shell script designed to help you keep your
system's hosts file up-to-date with the latest release from [StevenBlack's hosts
project](https://github.com/StevenBlack/hosts). Additionally, it allows you to
append your own custom hosts to the system's hosts file, giving you control over
local host resolution.

## Prerequisites

Before using this script, please ensure you have the following prerequisites:

1. **Unix-like Operating System**: This script is designed to work on Unix-like
   operating systems such as Linux and macOS.
2. **wget**: This script uses `wget` to download the latest hosts file from the
   StevenBlack repository.
3. **Root Access**: You need superuser (root) access to update the system's
   hosts file located at `/etc/hosts`.
4. **Custom Hosts File**: Optionally, you can have your own custom hosts file.
   By default, this script looks for it in the directory specified by the
   `XDG_CONFIG_HOME` environment variable. If the variable is not set, it
   defaults to `~/.config/hosts`. Ensure your custom hosts file is correctly
   formatted.

## Installation

1. Clone this repository or download the `hostupd` script:

   ```bash
   git clone https://github.com/i13e/hostupd.git
   ```

2. Run the script:

   ```bash
   ./hostupd
   ```

## Configuration

You can configure the script by editing the following variables in the script:

* `hosts_url`: URL to the hosts file you want to use. By default, it points to
  StevenBlack's recommended hosts file.
* `custom_hosts`: Path to your custom hosts file. By default, it uses the value
  of the `XDG_CONFIG_HOME` environment variable.
* `system_hosts`: Path to your system's hosts file. By default, it's set to
  `/etc/hosts`.

## Acknowledgments

This script is made possible by [StevenBlack's hosts project](https://github.com/StevenBlack/hosts),
which provides a high-quality hosts file.

## Disclaimer

Use this script responsibly and understand the changes it makes to your system.
Modifying your system's hosts file can affect network connectivity and should be
done with caution. The script is provided as-is, without any warranty or
guarantee.
