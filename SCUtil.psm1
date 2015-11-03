
Import-Module PSPKI

Function Get-Smartcard
{
    [OutputType([string])]
    param ([Parameter(Mandatory=$true)][string]$CommonName)

    $ca = Get-CertificationAuthority
    $certs = ($ca | get-issuedrequest -Property "CommonName", "Request.SubmittedWhen", "Request.CallerName" -filter "CertificateTemplate -eq Smartcard","NotAfter -ge $(Get-Date)" | Where-Object {$_.CommonName -like $CommonName})
    
    Write-Output $certs
}

Function Revoke-Smartcard
{
    [CmdLetBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]$SerialNumber,
        [string]$Reason="Unspecified"
    )

    begin {
        $ca = Get-CertificationAuthority
    }

    process {    
        $certs = ($ca | get-issuedrequest -Property "CommonName", "Request.SubmittedWhen", "Request.CallerName" -filter "CertificateTemplate -eq Smartcard","SerialNumber -eq $SerialNumber")
   
        if (-not $certs) {
            Write-Output "No certificates found"
            Break
        }

        foreach ($cert in $certs) {
            Write-Output $cert
            if ($PSCmdlet.ShouldProcess($cert.SerialNumber,"Revoke")) {
                Write-Output "Revoking certificate with serial number $SerialNumber. Reason: $reason"
                if  (-Not [bool]$WhatIfPreference.IsPresent) {
                    Revoke-Certificate -Request $cert -Reason $Reason 
                }
            }
        }

    }
}


