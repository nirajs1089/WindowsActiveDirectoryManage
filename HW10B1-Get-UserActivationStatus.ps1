[cmdletbinding()]


param(

        #********************P4**********************
        [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter

         ,
          [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $path
        ,
        #**********************P5*********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [string] $Server
        ,
        #**********************P6*********************
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
          
                    
                    Try
                    {

                            if(!($Filter))
                            {
                                              $GetActivationUser = (
                                                                        Get-ADUser `
                                                                        -Server $Server `
                                                                        -Credential $Credential `
                                                                        -Filter * | Where-Object DistinguishedName -like "*$path*" `
                                                                        -ErrorAction SilentlyContinue
                                                                    )
                                
                            }
                            elseif($Filter)
                            {
                                                $GetActivationUser = (
                                                                        Get-ADUser `
                                                                        -Server $Server `
                                                                        -Credential $Credential `
                                                                        -Filter $Filter | Where-Object DistinguishedName -like "*$path*" `
                                                                        -ErrorAction SilentlyContinue
                                                                    )
                            }   
                        
                             $GetActivationUser | `
                                                        Select-Object -Property SAMAccountName, `
                                                                                Name, `
                                                                                Enabled | Format-Table -AutoSize

                            <#foreach($GetUser in $GetActivationUser)
                            {
                            
                              $GetUser | `
                                                        Select-Object -Property Name, `
                                                                                SAMAccountName, `
                                                                                Enabled

                              $newObject   
                            }#>
                        }
                        Catch
                        {
                            Write-Output "ERROR"
                            Continue
                        }

        Write-Verbose "PROCESS finished..."

    }

    END
    {
        Write-Verbose "END starting..."
        Write-output "END"
        Write-Verbose "END finished..."
    }