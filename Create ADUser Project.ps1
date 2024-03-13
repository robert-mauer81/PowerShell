######https://github.com/starhound/ActiveDirectoryCreateUser/blob/main/AD_CREATE_USER.ps1
############     staround/ActiveDirectoryCreateUser GitHub Repository       #############
############Read Me location:  https://github.com/starhound/ActiveDirectoryCreateUser/blob/main/README.md
#Goal of this project is to take an original code created by the above author and utilize it in a lab environment.  In Order to gain experience and skills 
#utilizing existing PowerShell command scripts in my environment.  I will be using the Go Deploy Lab environment provided during my PAC12 Microsoft Systems &
#Software Academy Course.  I hope to gain experience and expertise in the implementation PowerShell Script into my environmentent.  I also hope to create a Graphical
#User Interface that will enable the input of New ADUser account information into the variable that will run the script (this was not includ).

NOTE: This all looks good but your Send-Mail function really should be a standalone tool int it's own module or script.

#Just in case the AD DS Module is not already loaded 
Import-Module activedirectory

#Load the System.Web assembly 
Add-Type -AssemblyName System.Web

#Elevate to Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$localPCNAme = $env:computername

Write-Output '==========================================================='
Write-Output "===                AD User Creation Script              ==="
Write-Output '==========================================================='

Write-Output ''

Write-Output "***********************************************************"
Write-Output "***     Please ensure you've created the user email     ***"
Write-Output "***     in cPanel before using this PowerShell script   ***"
Write-Output '***********************************************************'

#Check if PS-Remote is enabled, if not, enable it
If (Get-WmiObject -Class win32_service | Where-Object {$_.name -like "WinRM"}) {
    Write-Output 'PS Remoting Already Enabled'
    Write-Output "`n"    
} else {
    Write-Output "Enabling PS Remoting"
    Enable-PSRemoting -Force
    Write-Output "`n"
}

#Test connection to Domain Controller
if (!(Test-WSMan LON-DC1)) {
    Write-Output 'No connection to Domain Controller, closing'
    exit
}

#Grab user name
$AdminUser = $env:UserName

Write-Output "Connecting to Domain Controller"
Write-Output "`n"

#Connect to Domain Controller
Enter-PSSession -ComputerName LON-DC1 -Credential $AdminUser

Write-Output "Connection to Domain Controller established"
Write-Output "`n"

#Gather input about new user object  ***This is where the GUI will come in once I get this code working in my enviroment***
$FirstName = Read-Host -Prompt 'Input new user first name'
$LastName = Read-Host -Prompt 'Input new user last name'
$Email = Read-Host -Prompt 'Input new user email'
$Path = Read-Host -Prompt 'Input New user path (E.g. OU=IT,DC=Adatum,DC=com)'

#Formulate display name from first/last names
$DisplayName = $FirstName + '.' + $LastName 

Write-Output "`n"
Write-Output 'User Display Name will be: ' $DisplayName

#Generate Random Pwd
$Password = [System.Web.Security.Membership]::GeneratePassword(8,0)

#Covnert to SecureString for New-ADUser call
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

#Shows Administrator default password.  **Security concerns if account isn't imediately log in and password changed
Write-Output "`n"
Write-Output "User Password is: " $Password

New-ADUser -UserPrincipalName $DisplayName -Name $DisplayName -AccountPassword $SecurePassword -ChangePasswordAtLogon 1 -DisplayName $DisplayName -EmailAddress $Email -Enabled 1 -GivenName $FirstName -Surname $LastName -Path $Path

Write-Output "`n"
Write-Output "Created user."

#End DC01 Session
Exit-PSSession

#Notify employees
Write-Output "Starting Email Notification`n"

$Subject = "User Windows Logon Information"
$Body = "The following login information has been created for " + $FirstName + " " + $LastName + "`n"
$Body += "`tUser Email       : " + $Email + "`n"
$Body += "`tWindows Logon    : " + $DisplayName + "`n"
$Body += "`tWindows Password : " + $Password + "`n"

#this will send the eamil to the location you would like it "IT@YOUR_DOMAIN.com"  Must be updtated 
$IT = "it@adatum.com"

#TODO - File creation for SMTP credit storage + domain controller connection pwd
#SMTP Credits
$EMAIL_ACCOUNT = Read-Host -Prompt "Please enter your SMTP Account"
$EMAIL_PWD = Read-Host -Prompt "Please enter your SMTP Account Password"
$MAIL_SERVER = 'LON-SVR1.adatum.com'
$MAIL_PORT = 25

function Send-ToEmail([string]$emailUser) {
    $message = new-object Net.Mail.MailMessage;
    $message.From = $IT;
    $message.CC.Add($IT);
    $message.To.Add($email);
    $message.Subject = $Subject;
    $message.Body = $Body;
    $smtp = new-object Net.Mail.SmtpClient($MAIL_SERVER, $MAIL_PORT);
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($EMAIL_ACCOUNT, $EMAIL_PWD);
    $smtp.send($message);
    write-host "E-Mail notification Sent" ; 
}

Send-ToEmail($Email)

Read-Host -Prompt "Press Enter to exit."
#This worked to create New ADUsers with input information.  Now I will move on to combine my GUI project inot this. 
