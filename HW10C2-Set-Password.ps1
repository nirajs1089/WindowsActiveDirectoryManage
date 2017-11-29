
[cmdletbinding(
                DefaultParameterSetName="UserNameSet"
                )]


param(

        #********************P2**********************
        [Parameter(
                    ParameterSetName="UserNameSet",
                    Mandatory=$true, # $true,
                    valueFromPipeLine=$true
                    )]

        [string[]] $UserName

         ,
          [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $path
        ,
        #********************P4**********************
        [Parameter(
                    ParameterSetName="FilterSet",
                    Mandatory=$True, # $true,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter

         ,
        #********************P4**********************
        [Parameter(                    
                    Mandatory=$True, # $true,
                    valueFromPipeLine=$false
                    )]

        [string] $Password

         ,
         #********************P4**********************
        [Parameter(                    
                    Mandatory=$False, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $MustChangePWAtNextLogon

         ,
          #********************P4**********************
        [Parameter(                    
                    Mandatory=$False, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $Confirm = $True

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

                switch ($PSCmdlet.ParameterSetName) 
        
        {
            "UserNameSet" 
                        {

                                foreach($user in $UserName)
                                {
                                         Try
                                        {
                                    
                                                                                                $SetPasswordUser = (
                                                                                                    Get-ADUser `
                                                                                                    -Server $Server `
                                                                                                    -Credential $Credential `
                                                                                                    -Filter { Name -eq $user | Where-Object DistinguishedName -like "*$path*" }
                                                                                                )

                                                  Write-output "GetPasswordRule User USING userName " . $SetPasswordUser

                                                  Set-ADAccountPassword `
                                                                        -Identity $SetPasswordUser `
                                                                         -server $Server `
                                                                         -Credential $Credential  `
                                                                         -Confirm:$Confirm `
                                                                         -NewPassword (convertto-securestring $Password -asplaintext -force) `
                                                                         -ErrorAction SilentlyContinue                                                                                                                                  

                                                   Set-Aduser -Identity $SetPasswordUser `
                                                                -server $Server `
                                                                -Credential $Credential  `
                                                                -ChangePasswordAtLogon:$MustChangePWAtNextLogon `
                                                                -ErrorAction SilentlyContinue
                                                                 
                                                   $SetPasswordUser.Name
                                                                                     
                                
                                        }                                         
                                        Catch
                                        {
                                            Write-Output "ERROR"
                                            Continue
                                        }
                                }
                        }

            "FilterSet" 
                        {
                            Try
                               {

                                        if(!($Filter))
                                        {
                                          $SetPasswordUser = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Filter * | Where-Object DistinguishedName -like "*$path*" `
                                                                    -ErrorAction SilentlyContinue
                                                                )
                                
                                        }
                                        elseif($Filter)
                                        {
                                          $SetPasswordUser = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Filter $Filter | Where-Object DistinguishedName -like "*$path*" `
                                                                    -ErrorAction SilentlyContinue
                                                                )
                                        }  
                                }                                         
                                Catch
                                {
                                    Write-Output "ERROR"
                                    Continue
                                }                                         


                                        foreach($PasswordFilterUser in $SetPasswordUser)
                                        {
                                         Try
                                        
                                            {

                                                Set-ADAccountPassword -Identity $PasswordFilterUser `
                                                                        -server $Server `
                                                                        -Credential $Credential  `
                                                                        -Confirm:$Confirm `
                                                                        -NewPassword (convertto-securestring $Password -asplaintext -force) `
                                                                        -ErrorAction SilentlyContinue                                                              
                                             

                                                 Set-Aduser -Identity $PasswordFilterUser `
                                                            -server $Server `
                                                            -Credential $Credential  `
                                                            -ChangePasswordAtLogon $MustChangePWAtNextLogon `
                                                            -ErrorAction SilentlyContinue
                                                                 
                                                $PasswordFilterUser.Name
                                             }             
                                                                                  
                                            Catch
                                            {
                                                Write-Output "ERROR"
                                                Continue
                                            }
                                        }
                        }

        
        }
          


        Write-Verbose "PROCESS finished..."

    }

    END
    {
        Write-Verbose "END starting..."
        Write-output "END"
        Write-Verbose "END finished..."
    }