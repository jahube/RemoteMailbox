
ENABLE REMOTEMAILBOX 
enable-remotemailbox user@domain.com -shared -remoteroutingaddress alias@tenant.mail.onmicrosoft.com

ENABLE ARCHIVE
enable-remotemailbox user@domain.com -archive

----------------------------------------------------------
EXCHANGEGUID / ARCHIVEGUID HARDMATCH ("BACKSYNC" existing cloud only Mailbox to become remote)
----------------------------------------------------------

CLOUD
Get-mailbox USER | FL displayname,Exchangeguid,ArchiveGuid      # COPY VALUES

----------------------------------------------------------

EXCHANGE GUID
-------------
Exchange Management Shell / Onprem

set-remotemailbox user@domain.com -ExchangeGuid "CLOUD ExchangeGUID"  # PASTE CLOUD Exchangeguid

AD / Domaincontroller

[guid]$MailboxGuid = "CLOUD ExchangeGUID"                       # PASTE CLOUD Exchangeguid

$mbx = get-aduser "USERNAME" -Properties *
Set-ADUser $mbx.DistinguishedName -Replace @{msExchMailboxGuid=$MailboxGuid.ToByteArray()}

----------------------------------------------------------

ARCHIVE GUID
-------------
Exchange Management Shell / Onprem

set-remotemailbox user@domain.com -ArchiveGuid "CLOUD ArchiveGuid"    # PASTE CLOUD ArchiveGuid

AD / Domaincontroller

[guid]$Archiveguid = "CLOUD ARCHIVEGUID"                        # PASTE CLOUD ArchiveGuid

$mbx = get-aduser "USERNAME" -Properties *
Set-ADUser $mbx.DistinguishedName -Replace @{msExchArchiveGUID=$Archiveguid.ToByteArray()}

----------------------------------------------------------
GET Exchange

Get-remotemailbox USER | FL displayname,Exchangeguid,ArchiveGuid

GET / AD
$mbx = get-aduser "USERNAME" -Properties *

# below converts the Byte arrays in cloud readable format, its quick and helpful
[guid]$mbx.msExchMailboxGuid #converted Mailbox GUID
[guid]$mbx.msExchArchiveGUID  #converted Archive GUID
[guid]$mbx.msExchDisabledArchiveGUID  #converted Previousarchive GUID

$mbx.msExchRecipientDisplayType
$mbx.msExchRecipientTypeDetails
$mbx.msExchRemoteRecipientType #check REMOTE recipienttype

REFERENCE
[guid]$DisabledArchiveguid = "DISABLED ARCHIVE GUID HERE"             # set disabled archive guid (before enabling / not necessary)
Set-ADUser $mbx.DistinguishedName -Replace @{msExchDisabledArchiveGUID=$DisabledArchiveguid.ToByteArray()}

Set-ADUser $mbx.DistinguishedName -clear msExchDisabledArchiveGUID    # clear disabledArchive GUID

