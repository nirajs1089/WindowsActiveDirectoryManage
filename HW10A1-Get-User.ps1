[cmdletbinding()]


param(

        #********************P1**********************
        [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter
        ,
        #**********************P2*********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [string] $Server
        ,
        #**********************P2*********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [PSCredential] $Credential
)

BEGIN
{
Write-Verbose "BEGIN starting..."
Write-output "BEGIN"
Write-Verbose "BEGIN finished..."
}


PROCESS
{
Write-Verbose "PROCESS starting..."
Write-output "PROCESS"

    if(!($Filter)) #$pFilter='*' -or
    {
             Get-ADUser `
                        -filter * `
                        -Server $Server `
                        -Credential $Credential
            #(Get-ADUser -filter * -Server $pServer -Credential $pCredential).Name
    }
    elseif($Filter)
    {
            (Get-ADUser `
                        -filter $Filter `
                        -Server $Server `
                        -Credential $Credential)
            #(Get-ADUser -filter { Name -like "*Shah*" } -Server $pServer -Credential $pCredential).Name
    }

 

Write-Verbose "PROCESS finished..."

}



END
{
Write-Verbose "END starting..."
Write-output "END"
Write-Verbose "END finished..."
}