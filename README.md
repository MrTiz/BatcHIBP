# BatcHIBP
"Have I Been Pwned?" is a website that allows Internet users to check whether their personal data has been compromised by data breaches. This script allows you to search for multiple passwords using the "Have I Been Pwned?" API.

## Getting Started
Thanks to these instructions, you can get a copy of the project up and run on your local machine for development and testing purposes.

### Prerequisites
- PowerShell

### Installation
```bash
git clone https://github.com/MrTiz/BatcHIBP.git
```

## Usage
```powershell
PowerShell.exe -ExecutionPolicy Bypass -File .\BatcHIBP.ps1 -PasswordsFile <PasswordsFile>
```

## Examples
```powershell
PowerShell.exe -ExecutionPolicy Bypass -File .\BatcHIBP.ps1 -PasswordsFile C:\Users\MrTiz\Desktop\rockyou.txt

--------------------------------
Search in Progress
    Progress -> 18 of 14344391 - 0.000125484588366282 %
    [                                                                      ]
--------------------------------

--------------------------------
      ID |      COUNT | Password
--------------------------------
       1 |   24230577 | 123456
       2 |    2493390 | 12345
       3 |    8012567 | 123456789
       4 |    3861493 | password
       5 |    1655692 | iloveyou
       6 |     496596 | princess
       7 |    2562301 | 1234567
       8 |      23747 | rockyou
       9 |    3026692 | 12345678
      10 |    2897638 | abc123
      11 |     291474 | nicole
      12 |     388831 | daniel
      13 |     246951 | babygirl
      14 |    1000081 | monkey
      15 |     275971 | lovely
      16 |     338814 | jessica
      17 |     975925 | 654321
      18 |     443522 | michael
...
```

## Contributing

Contributions are what make the open source community such a good place to learn, inspire, and create. Any contributions you can provide are greatly appreciated.

- Fork the Project
- Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
- Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
- Push to the Branch (`git push origin feature/AmazingFeature`)
- Open a Pull Request

## Authors
- **[Tiziano Marra](https://github.com/MrTiz)**

## Disclaimer
[have i been pwned?](https://haveibeenpwned.com) is not associated with, nor it does not endorse nor sponsor this script. I'm not affiliated with the authors of _have i been pwned?_. This is just an attempt to have a script that can evaluate the compromise of a set of passwords.

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This project is licensed under the GNU General Public License v3.0 - see the 
[LICENSE](https://github.com/MrTiz/BatcHIBP/blob/master/LICENSE) file for details.
