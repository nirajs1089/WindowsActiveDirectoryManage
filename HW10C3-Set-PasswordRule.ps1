
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
                    Mandatory=$False, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $MustChangePWAtNextLogon=$false

         ,
           #********************P4**********************
        [Parameter(                    
                    Mandatory=$False, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $canChangePW= $True

         ,
           #********************P4**********************
        [Parameter(                    
                    Mandatory=$False, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $pwNeverExpires = $True

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

        $MustChangePWAtNextLogonUsed = $PSBoundParameters.ContainsKey('pMustChangePWAtNextLogon')
        $canChangePWUsed = $PSBoundParameters.ContainsKey('pcanChangePW')
        $pwNeverExpiresUsed = $PSBoundParameters.ContainsKey('pwNeverExpires')

        Write-Verbose "BEGIN finished..."
    }


    PROCESS
    {
        Write-Verbose "PROCESS starting..."
        Write-output "PROCESS"

        $InvcanChangePW = -not $canChangePW

        if((!$MustChangePWAtNextLogonUsed) -and (!$canChangePWUsed) -and (!$pwNeverExpiresUsed))
            {
                Write-Output "ERROR-Please Provide atleast one parameter"
                Continue
            }

                switch ($PSCmdlet.ParameterSetName) 
        
        {
            "UserNameSet" 
                        {

                                foreach($userName in $UserName)
                                 Try
                                       {
                                        {
                                          $SetPasswordUser = (
                                                            Get-ADUser `
                                                            -Server $Server `
                                                            -Credential $Credential `
                                                            -Filter { Name -eq $userName } | Where-Object DistinguishedName -like "*$path*"
                                                        )

                                          Write-output "SetPasswordRule User USING userName " . $SetPasswordUser                                                                                                                                                                           


                                          Set-ADUser `
                                                        -Identity $SetPasswordUser `
                                                        -Server $Server `
                                                        -Credential $Credential `
                                                        -CannotChangePassword $InvcanChangePW `
                                                        -PasswordNeverExpires $pwNeverExpires `
                                                        -ChangePasswordAtLogon $MustChangePWAtNextLogon `
                                                        -ErrorAction SilentlyContinue                                                                                                                                                                                                                                  
                                                        

                                           $newObject = New-Object PSObject

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name SAMAccountName `
                                                                -Value $SetPasswordUser | Select-Object SAMAccountName `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name Name `
                                                                -Value ($SetPasswordUser | Select-Object Name) `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name MustChangePWAtNextLogon `
                                                                -Value $SetPasswordUser | Select-Object PasswordExpired `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name CanChangePW `
                                                                -Value -not ($SetPasswordUser | Select-Object CannotChangePassword) `
                                                                -MemberType NoteProperty
    
                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name PWNeverExpires `
                                                                -Value ($SetPasswordUser | Select-Object PasswordNeverExpires) `
                                                                -MemberType NoteProperty

                                                    $newObject
                                                                 
                                            
                                                                                     
                                }
                                        }
                                        Catch
                                        {
                                            Write-Output "ERROR"
                                            Continue
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


                                        foreach($passwordFilterUser in $SetPasswordUser)

                                        Try
                                       {
                                        {                                             

                                             Set-Aduser -Identity $asswordFilterUser `
                                                        -server $Server `
                                                        -Credential $Credential  `
                                                        -ChangePasswordAtLogon $MustChangePWAtNextLogon `
                                                        -CannotChangePassword $InvcanChangePW `
                                                        -PasswordNeverExpires $pwNeverExpires `
                                                        -ErrorAction SilentlyContinue
                                                                 
                                         }        
                                         }
                                        Catch
                                        {
                                            Write-Output "ERROR"
                                            Continue
                                        }  

                                         $passwordFilterUser | Select-Object -Property SAMAccountName, `
                                                Name, `
                                                ChangePasswordAtLogon, `
                                                CannotChangePassword, `
                                                PasswordNeverExpires    
                                                
                                                $newObject = New-Object PSObject

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name SAMAccountName `
                                                                -Value $passwordFilterUser | Select-Object SAMAccountName `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name Name `
                                                                -Value ($passwordFilterUser | Select-Object Name) `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name MustChangePWAtNextLogon `
                                                                -Value $passwordFilterUser | Select-Object PasswordExpired `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name CanChangePW `
                                                                -Value -not ($passwordFilterUser | Select-Object CannotChangePassword) `
                                                                -MemberType NoteProperty
    
                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name PWNeverExpires `
                                                                -Value ($passwordFilterUser | Select-Object PasswordNeverExpires) `
                                                                -MemberType NoteProperty

                                                    $newObject 


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