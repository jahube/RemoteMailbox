# create NEW remotemailbox (Enable before Archive - DISABLE after Archive
# create user in AD and run below
# ENABLE Remotemailbox
enable-remotemailbox user@domain.com -remoteroutingaddress alias@tenant.mail.onmicrosoft.com

# AD Version 

#Abfragen
$mbx = get-aduser "USERNAME" -Properties *
# ODER / OR
$mbx = get-aduser -Filter {mail -eq "user.name@domain.com"} -Properties *
# ODER / OR
$mbx = get-aduser -Filter {userprincipalname -like "user.name*"} -Properties *

# user from above
$USER = $mbx.DistinguishedName

# SamAccountname / manual
$USER = "SamAccountname"

Set-ADUser $USER -Replace @{msExchRemoteRecipientType='1'}   # CHECK TABLE BELOW
Set-ADUser $USER -Replace @{msExchRecipientDisplayType='-2147483642'}
Set-ADUser $USER -Replace @{msExchRecipientTypeDetails='2147483648'}

$alias = 'user.name'

$mail  = 'user.name@domain.com'

$RemoteAdresse = "$alias@tenant.mail.onmicrosoft.com" # from $Alias (Variable)

# $RemoteAdresse = "user.name@tenant.mail.onmicrosoft.com" #manual

Set-ADUser $USER -Replace @{TargetAddress="SMTP:$RemoteAdresse"}

Set-ADUser $USER -Add @{ProxyAddresses="smtp:$RemoteAdresse"}

Set-ADUser $USER -Replace @{mailNickname="$alias"}

Set-ADUser $USER -Replace @{mail="$mail"}

# ENABLE Remotemailbox ARCHIVE                      * (Enable after mailbox - DISABLE before mailbox)
enable-remotemailbox user@domain.com -archive

# OR

Set-ADUser $USER -Replace @{msExchRemoteRecipientType='3'}   # ProvisionMailbox, ProvisionArchive 

# Reference
# https://answers.microsoft.com/en-us/msoffice/forum/msoffice_o365admin-mso_exchon-mso_o365b/recipient-type-values/7c2620e5-9870-48ba-b5c2-7772c739c651

# msExchRemoteRecipientType
# enable-mailbox USER always with -remoteroutingaddress alias@tenant.mail.onmicrosoft.com (shortened for overview) (enable-Archive without)
<#
1	ProvisionMailbox                       = enable-mailbox USER                                                                     (PROVISION)
2	ProvisionArchive (On-Prem Mailbox)     = enable-mailbox USER -remotearchive -archivedomain tenant.mail.onmicrosoft.com           (PROVISION remote archive)
3	ProvisionMailbox, ProvisionArchive     = Enable-remotemailbox USER AND Enable-remotemailbox USR -archive                         (PROVISION)
4	Migrated (UserMailbox)                 = Enable-remotemailbox USER (Migrated)
6	ProvisionArchive, Migrated             = Enable-remotemailbox USER -archive (Migrated)
8	DeprovisionMailbox                     = Disable-remotemailbox USER
10	ProvisionArchive, DeprovisionMailbox   = Enable-remotemailbox USER -archive AND Disable-(remote)mailbox USR (?)
16	DeprovisionArchive (On-Prem Mailbox)   = Disable-mailbox -remotearchive
17	ProvisionMailbox, DeprovisionArchive   = Enable-remotemailbox USER AND Disable-remotemailbox USER -archive
20	Migrated, DeprovisionArchive           = Disable-remotemailbox USER -archive (Migrated)
24	DeprovisionMailbox, DeprovisionArchive = Disable-remotemailbox USER -archive AND Disable-remotemailbox USR
33	ProvisionMailbox, RoomMailbox          = Enable-remotemailbox USER -ROOM                                                         (PROVISION)
35	ProvisionMailbox, ProvisionArchive, RoomMailbox    = Enable-remotemailbox USER -ROOM      AND  Enable-remotemailbox USR -archive (PROVISION)
36	Migrated, RoomMailbox                              = Enable-remotemailbox USER -ROOM                                             (Migrated)
38	ProvisionArchive,Migrated, RoomMailbox             = Enable-remotemailbox USER -ROOM      AND  Enable-remotemailbox USR -archive (Migrated)
49	ProvisionMailbox, DeprovisionArchive, RoomMailbox  = Enable-remotemailbox USER -ROOM      AND Disable-remotemailbox USR -archive
52	Migrated, DeprovisionArchive, RoomMailbox          = Enable-remotemailbox USER -ROOM      AND Disable-remotemailbox USR -archive (Migrated)
65	ProvisionMailbox, EquipmentMailbox                 = Enable-remotemailbox USER -Equipment                                        (PROVISION)
67	ProvisionMailbox,ProvisionArchive,EquipmentMailbox = Enable-remotemailbox USER -Equipment AND  Enable-remotemailbox USR -archive (PROVISION)
68	Migrated, EquipmentMailbox                         = Enable-remotemailbox USER -Equipment                                        (Migrated)
70	ProvisionArchive, Migrated, EquipmentMailbox       = Enable-remotemailbox USER -Equipment AND  Enable-remotemailbox USR -archive (Migrated MBX + archive PROVISION))
81	ProvisionMailbox, DeprovsnArchive,EquipmentMailbox = Enable-remotemailbox USER -Equipment AND Disable-remotemailbox USR -archive (PROVISION)
84	Migrated, DeprovisionArchive, EquipmentMailbox     = Enable-remotemailbox USER -Equipment AND Disable-remotemailbox USR -archive (Migrated)
97	ProvisionMailbox, SharedMailbox                    = Enable-remotemailbox USER -SHARED                                           (PROVISION)
100	Migrated, SharedMailbox                            = Enable-remotemailbox USER -SHARED                                           (Migrated)
102	ProvisionArchive, Migrated, SharedMailbox          = Enable-remotemailbox USER -SHARED    AND  Enable-remotemailbox USR -archive (Migrated)
116	Migrated, DeprovisionArchive, SharedMailbox        = Enable-remotemailbox USER -SHARED    AND Disable-remotemailbox USR -archive (Migrated)
#>