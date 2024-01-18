# AutoADenum

This is my first experience with PowerShell, but I plan to enhance it in the future.

## What is this?

AutoADenum is a script designed to collect information about users, machines, and groups in the Active Directory environment. It utilizes LDAP queries, the DirectorySearcher Class, and the DirectoryEntry Class for information collection and enumeration.

By default, it determines the Domain Controller name and distinguished name. If you want to change it, you can specify the "Name" for the parameter -PDC and the "Distinguished name" for -DN in the following syntax:

"The domain in the example is green.com"
```powershell
PS> .\AutoADenum.ps1 -PDC "DC1.green.com" -DN "DC=green,DC=com"
```


#What information does it collect?
Users:
    All Users ,
    Description (Yellow Color) ,
    SPN (Green Color)

Machines:
    DNS Hostname ,
    Operating System ,
    OS Version

Groups:
    Custom Group (Green Color) ,
    Active Directory Security Groups (Red Color) 

In general, it gathers a variety of information, but you can specify the details you want to collect

for users : "U"
```powershell
PS> .\AutoADenum.ps1 -ObjType U
```
![Users](https://github.com/Palehab/AutoADEnum/blob/main/images/Users.png)

for Machines : "M"
```powershell
PS> .\AutoADenum.ps1 -ObjType M
```
![Machines](https://github.com/Palehab/AutoADEnum/blob/main/images/Mashine.png)

for Groups : "G"
```powershell
PS> .\AutoADenum.ps1 -ObjType G
```
![Groups](https://github.com/Palehab/AutoADEnum/blob/main/images/Groups.png)


  
