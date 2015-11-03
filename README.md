# SCUtil

(Prereq: PSPKI - http://pspki.codeplex.com)

Get-Smartcard -CommonName "Commonname, User"

Get-Smartcard -CommonName "\*user\*"

Revoke-Smartcard -SerialNumber 190000001562ffb398518e9aa2000100000015 -Reason Superseded

(Reasons: Unspecified - (default),KeyCompromise,CACompromise,AffiliationChanged,Superseded,CeaseOfOperation,Hold, Unrevoke)

Get-Smartcard -CommonName "Commonname, User" | Revoke-Smartcard -Reason CeaseOfOperation
