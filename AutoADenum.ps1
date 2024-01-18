Param(
	[string]$PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.name ,
	[string]$DN = ([adsi]'').distinguishedName ,
	[string]$ObjType = ''
)
$LDAPpath = "LDAP://$pdc/$dn"
$Entry = New-Object System.DirectoryServices.DirectoryEntry("$LDAPpath")



function Users-S {
	$SPNList = @()
	$DirSerUsers = New-Object System.DirectoryServices.DirectorySearcher($Entry,"samAccountType=805306368")
	$Users = $DirSerUsers.FindALL()

	Write-Host -BackgroundColor Yellow  -ForegroundColor Red "-------------- Users -----------------"
	foreach( $User in $Users ){
	
		if($User.Properties.serviceprincipalname -ne $null){
		$SPNList += $User
		}else {
		write-host "=> "$User.Properties.cn
		if($User.Properties.description -ne $null ){
			write-host  -ForegroundColor Yellow "Comment : "$User.Properties.description
			write-host "-----------------------------------"
			}
	}
	
	
	}
	write-host "----------------ServicePrincipalName-------------------"
	foreach ($SPN in $SPNList){
		write-host  -ForegroundColor Green "SPN : "$SPN.Properties.serviceprincipalname
		write-host  -ForegroundColor Green "SPN-Name : "$SPN.Properties.name
		write-host "MemberOF : "
		$SPN.Properties.memberof
		write-host "-----------------------------------"
	}
	
}
function Machines-S {
	$DirSerMachines = New-Object System.DirectoryServices.DirectorySearcher($Entry,"samAccountType=805306369")
	$Machines = $DirSerMachines.FindALL()
	Write-Host -BackgroundColor Yellow  -ForegroundColor Red "-------------  Machine ------------------"
	foreach( $Machine in $Machines ){
		write-host " Name : " $Machine.Properties.cn
		write-host " DNShostName : " $Machine.Properties.dnshostname
		write-host " OperatingSystem : " $Machine.Properties.operatingsystem
		write-host " OS-Version : " $Machine.Properties.operatingsystemversion
		Write-Host "--------------------"
}
	
}
function Groups-S {
	$DirSerGroups = New-Object System.DirectoryServices.DirectorySearcher($Entry,"objectCategory=group")
	$Groups = $DirSerGroups.FindALL()
	Write-Host  -BackgroundColor Yellow  -ForegroundColor Red "-------------- Groups -----------------"
	foreach( $Group in $Groups ){
	
	
		$S  = $false
		$GroupName =""
		Foreach ($DefaultGroup in $GroupList){
			
			if( $Group.Properties.name -eq $DefaultGroup ){
			$S  = $true
			
			break	
			}
		
		}
		if ($S){
		
		
		Write-Host -ForegroundColor Red  $Group.Properties.cn
		}else{
		Write-Host -ForegroundColor Green  $Group.Properties.cn  "<=Custom Group"
		Write-Host -ForegroundColor yellow "Member : "
		 $Group.Properties.member
		Write-Host  -ForegroundColor yellow "MemberOF : "
		 $Group.Properties.memberof
		
		
		}
			
	}
	

}

$GroupList = @(
"Access Control Assistance Operators",
"Account Operators",
"Administrators",
"Allowed RODC Password Replication",
"Backup Operators",
"Certificate Service DCOM Access",
"Cert Publishers",
"Cloneable Domain Controllers",
"Cryptographic Operators",
"Denied RODC Password Replication",
"Device Owners",
"DHCP Administrators",
"DHCP Users",
"Distributed COM Users",
"DnsUpdateProxy",
"DnsAdmins",
"Domain Admins",
"Domain Computers",
"Domain Controllers",
"Domain Guests",
"Domain Users",
"Enterprise Admins",
"Enterprise Key Admins",
"Enterprise Read-only Domain Controllers",
"Event Log Readers",
"Group Policy Creator Owners",
"Guests",
"Hyper-V Administrators",
"IIS_IUSRS",
"Incoming Forest Trust Builders",
"Key Admins",
"Network Configuration Operators",
"Performance Log Users",
"Performance Monitor Users",
"Print Operators",
"Protected Users",
"RAS and IAS Servers",
"RDS Endpoint Servers",
"RDS Management Servers",
"RDS Remote Access Servers",
"Read-only Domain Controllers",
"Remote Desktop Users",
"Remote Management Users",
"Replicator",
"Schema Admins",
"Server Operators",
"Storage Replica Administrators",
"System Managed Accounts",
"Terminal Server License Servers",
"Users",
"Windows Authorization Access",
"WinRMRemoteWMIUsers_",
"Allowed RODC Password Replication Group",
"Denied RODC Password Replication Group",
"Windows Authorization Access Group",
"Pre-Windows 2000 Compatible Access"

#security groups
)
switch ($ObjType) {
    "G" {
        Groups-S
    }
    "M" {
        Machines-S
    }
    "U" {
        Users-S
    }
    Default {
		Users-S
		Machines-S
		Groups-S
    }
}


