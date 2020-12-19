
ONE

$user = "affected@user.com"

$Mailbox = Get-EXOMailbox -Identity $user  # Cloud

# Onprem
$param = @{     Name = $Mailbox.Name
               Alias = $Mailbox.Alias
         DisplayName = $Mailbox.DisplayName
RemoteRoutingAddress = $($Mailbox.Alias + '@tenant.mail.onmicrosoft.com').ToString()
Password = (ConvertTo-SecureString -String 'P@ssW0rd' -AsPlainText -Force)
ResetPasswordOnNextLogon = $false }
New-Mailbox @param


COMPLETE CLOUD > ONPREM

connect-exchangeonline -prefix XYZ -userprincipalname ADMIN

$MBXs = Get-EXOMailbox -resultsize unlimited
Foreach ($M in $MBXs) {
$param = @{         Name = $M.Name
                   Alias = $M.Alias
             DisplayName = $M.DisplayName
    RemoteRoutingAddress = $($M.Alias + '@tenant.mail.onmicrosoft.com').ToString()
                Password = (ConvertTo-SecureString -String 'P@ssW0rd' -AsPlainText -Force)
ResetPasswordOnNextLogon = $true }
              New-RemoteMailbox @param  }


$MBXs = Get-EXOMailuser -resultsize unlimited
Foreach ($MU in $MUs) {
$param = @{         Name = $MU.Name
                   Alias = $MU.Alias
             DisplayName = $MU.DisplayName
    RemoteRoutingAddress = $($MU.Alias + '@tenant.mail.onmicrosoft.com').ToString()
                Password = (ConvertTo-SecureString -String 'P@ssW0rd' -AsPlainText -Force)
ResetPasswordOnNextLogon = $true }
              New-Mailbox @param  }


clean softdeleted users
###############

Install-Module MSOnline

Connect-MsolService

Get-MsolUser -UserPrincipalName "affected@user.com" | Remove-MsolUser
Get-MsolUser -UserPrincipalName "affected@user.com" -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin

Get-MsolUser -ObjectId dd5fadd7-f80b-4912-93c2-d36eb3fdb564 | Remove-MsolUser
Get-MsolUser -ObjectId dd5fadd7-f80b-4912-93c2-d36eb3fdb564 -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin