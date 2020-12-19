# create NEW remotemailbox (Enable before Archive - DISABLE after Archive
# create user in AD and run below
# ENABLE Remotemailbox
enable-remotemailbox user@domain.com -remoteroutingaddress alias@tenant.mail.onmicrosoft.com

# AD Version 
$mbx = get-aduser "USERNAME" -Properties *
Set-ADUser $mbx.DistinguishedName -Replace @{msExchRemoteRecipientType='3'}   # CHECK TABLE BELOW
Set-ADUser $mbx.DistinguishedName -Replace @{msExchRecipientDisplayType='-2147483642'}
Set-ADUser $mbx.DistinguishedName -Replace @{msExchRecipientTypeDetails='2147483648'}

# ENABLE Remotemailbox ARCHIVE                      * (Enable after mailbox - DISABLE before mailbox) 

enable-remotemailbox user@domain.com -archive

# Reference
# https://answers.microsoft.com/en-us/msoffice/forum/msoffice_o365admin-mso_exchon-mso_o365b/recipient-type-values/7c2620e5-9870-48ba-b5c2-7772c739c651

# msExchRemoteRecipientType
# enable-mailbox USER always with -remoteroutingaddress alias@tenant.mail.onmicrosoft.com (shortened for overview) (enable-Archive without)

1	ProvisionMailbox                       = enable-mailbox USER
2	ProvisionArchive (On-Prem Mailbox)     = enable-mailbox USER -remotearchive -archivedomain tenant.mail.onmicrosoft.com
3	ProvisionMailbox, ProvisionArchive     = Enable-remotemailbox USER AND Enable-remotemailbox USR -archive
4	Migrated (UserMailbox)                 = Enable-remotemailbox USER (Migrated)
6	ProvisionArchive, Migrated             = Enable-remotemailbox USER -archive (Migrated)
8	DeprovisionMailbox                     = Disable-remotemailbox USER
10	ProvisionArchive, DeprovisionMailbox   = Enable-remotemailbox USER -archive AND Disable-(remote)mailbox USR (?)
16	DeprovisionArchive (On-Prem Mailbox)   = Disable-mailbox -remotearchive
17	ProvisionMailbox, DeprovisionArchive   = Enable-remotemailbox USER AND Disable-remotemailbox USER -archive
20	Migrated, DeprovisionArchive           = Disable-remotemailbox USER -archive (Migrated)
24	DeprovisionMailbox, DeprovisionArchive = Disable-remotemailbox USER -archive AND Disable-remotemailbox USR
33	ProvisionMailbox, RoomMailbox          = Enable-remotemailbox USER -ROOM
35	ProvisionMailbox, ProvisionArchive, RoomMailbox    = Enable-remotemailbox USER -ROOM      AND  Enable-remotemailbox USR -archive
36	Migrated, RoomMailbox                              = Enable-remotemailbox USER -ROOM (Migrated)
38	ProvisionArchive,Migrated, RoomMailbox             = Enable-remotemailbox USER -ROOM      AND  Enable-remotemailbox USR -archive (Migrated)
49	ProvisionMailbox, DeprovisionArchive, RoomMailbox  = Enable-remotemailbox USER -ROOM      AND Disable-remotemailbox USR -archive
52	Migrated, DeprovisionArchive, RoomMailbox          = Enable-remotemailbox USER -ROOM      AND Disable-remotemailbox USR -archive (Migrated)
65	ProvisionMailbox, EquipmentMailbox                 = Enable-remotemailbox USER -Equipment
67	ProvisionMailbox,ProvisionArchive,EquipmentMailbox = Enable-remotemailbox USER -Equipment AND  Enable-remotemailbox USR -archive
68	Migrated, EquipmentMailbox                         = Enable-remotemailbox USER -Equipment (Migrated)
70	ProvisionArchive, Migrated, EquipmentMailbox       = Enable-remotemailbox USER -Equipment AND  Enable-remotemailbox USR -archive (Migrated)  (?)
81	ProvisionMailbox, DeprovsnArchive,EquipmentMailbox = Enable-remotemailbox USER -Equipment AND Disable-remotemailbox USR -archive
84	Migrated, DeprovisionArchive, EquipmentMailbox     = Enable-remotemailbox USER -Equipment AND Disable-remotemailbox USR -archive (Migrated)
100	Migrated, SharedMailbox                            = Enable-remotemailbox USER -SHARED (Migrated)
102	ProvisionArchive, Migrated, SharedMailbox          = Enable-remotemailbox USER -SHARED    AND  Enable-remotemailbox USR -archive (Migrated)
116	Migrated, DeprovisionArchive, SharedMailbox        = Enable-remotemailbox USER -SHARED    AND Disable-remotemailbox USR -archive (Migrated)