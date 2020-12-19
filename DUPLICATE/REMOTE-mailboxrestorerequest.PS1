# [block]

$cred = Get-Credential

$Param = @{ RemoteHostName = "mail.contoso.com" 
          RemoteCredential = $cred
        SourceStoreMailbox = "exchange guid of disconnected mailbox"
            TargetMailbox  = "exchange guid of cloud mailbox"
        RemoteDatabaseGuid = "guid of on-premises database"
         RemoteRestoreType = DisconnectedMailbox }

New-MailboxRestoreRequest @Param


# [line]

$cred = Get-Credential

New-MailboxRestoreRequest -RemoteHostName "mail.contoso.com" -RemoteCredential $cred -SourceStoreMailbox "exchange guid of disconnected mailbox" -TargetMailbox "exchange guid of cloud mailbox" -RemoteDatabaseGuid "guid of on-premises database" -RemoteRestoreType DisconnectedMailbox