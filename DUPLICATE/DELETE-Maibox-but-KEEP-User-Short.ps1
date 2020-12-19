
# DELETE-Maibox-but-KEEP-User - CONFIRM to avoid ************ DATALOSS **************

# modify affected user
$user = "affected@user.com" 

Get-OrganizationConfig | fl *hold*
Get-Mailbox $user | fl *hold*
Get-Mailbox $user|fl compl*,delay*,inplace*
Set-Mailbox $user -ExcludeFromOrgHolds $true

# REMOVE LICENSE + wait until softdeleted (disappears in exchange admincenter / (mailbox) recipients

set-mailbox $user -type shared # converting to shared pushes the license removal update

# disable-mailbox $user

get-mailbox -softdeletedmailbox $user | set-mailbox -ExcludeFromAllOrgHolds # remove holds if applicable

# permanently disable
disable-mailbox $user -PermanentlyDisable -IgnoreLegalHold

# remove recipienttype mailbox --> mailuser
Set-User $user -PermanentlyClearPreviousMailboxInfo

get-recipient $user | fl *recipient*

# wait after license + mailbox removed + run until recipienttype changes mailbox --> mailuser
# then reassign license
