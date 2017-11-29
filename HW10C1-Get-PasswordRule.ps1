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
                    Mandatory=$false, # $true,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter

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
                                                    $GetPasswordRuleUser = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Filter { Name -eq $user } | Where-Object DistinguishedName -like "*$path*" `
                                                                    -Properties * `
                                                                    -ErrorAction SilentlyContinue
                                                                )

                                                    #Write-output "GetPasswordRule User USING userName " . $GetPasswordRuleUser
                                            
                                                    $GetPasswordRuleUser | `
                                                                            Select-Object -Property SAMAccountName, `
                                                                                                        Name, `
                                                                                                        PasswordExpired, `
                                                                                                        CannotChangePassword, `
                                                                                                        PasswordNeverExpires


                                                                                                        $accName = ($GetPasswordRuleUser | Select-Object SAMAccountName)
                                                                                                        $pExp = ($GetPasswordRuleUser | Select-Object PasswordExpired)
                                                                                                        $canPass = -not ($GetPasswordRuleUser | Select-Object CannotChangePassword)
                                                $newObject = New-Object PSObject

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name SAMAccountName `
                                                                -Value $accName `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name Name `
                                                                -Value ($GetPasswordRuleUser | Select-Object Name) `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name MustChangePWAtNextLogon `
                                                                -Value $pExp `
                                                                -MemberType NoteProperty

                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name CanChangePW `
                                                                -Value $canPass `
                                                                -MemberType NoteProperty
    
                                                        Add-Member `
                                                                -InputObject $newObject `
                                                                -Name PWNeverExpires `
                                                                -Value ($GetPasswordRuleUser | Select-Object PasswordNeverExpires) `
                                                                -MemberType NoteProperty

                                                    $newObject
                                                    <#$newObject.SAMAccountName
                                                    $newObject.Name
                                                    $newObject.MustChangePWAtNextLogon
                                                    $newObject.CanChangePW
                                                    $newObject.PWNeverExpires#>
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
                                          $GetPasswordRuleUser = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Filter * | Where-Object DistinguishedName -like "*$path*" `
                                                                    -Properties * `
                                                                    -ErrorAction SilentlyContinue
                                                                )
                                
                                        }
                                        elseif($Filter)
                                        {
                                          $GetPasswordRuleUser = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Filter $Filter | Where-Object DistinguishedName -like "*$path*" `
                                                                    -Properties * `
                                                                    -ErrorAction SilentlyContinue
                                                                )
                                        } 
                        }                                         
                        Catch
                            {
                                Write-Output "ERROR"
                                Continue
                            }                 
        
    
                                     foreach($user in $GetPasswordRuleUser)
                                     Try
                                    {
                                            {
                                          $user | `
                                                                    Select-Object -Property SAMAccountName, `
                                                                                              Name, `
                                                                                              PasswordExpired, `
                                                                                              CannotChangePassword, `
                                                                                              PasswordNeverExpires

                                           $accName = ($user | Select-Object SAMAccountName)
                                           $pExp = ($user | Select-Object PasswordExpired)
                                           $canPass = -not ($user | Select-Object CannotChangePassword)

                                            $newObject = New-Object PSObject

                                                Add-Member `
                                                        -InputObject $newObject `
                                                        -Name SAMAccountName `
                                                        -Value $accName `
                                                        -MemberType NoteProperty

                                                Add-Member `
                                                        -InputObject $newObject `
                                                        -Name Name `
                                                        -Value ($user | Select-Object Name) `
                                                        -MemberType NoteProperty

                                                Add-Member `
                                                        -InputObject $newObject `
                                                        -Name MustChangePWAtNextLogon `
                                                        -Value $pExp `
                                                        -MemberType NoteProperty

                                                Add-Member `
                                                        -InputObject $newObject `
                                                        -Name CanChangePW `
                                                        -Value $canPass `
                                                        -MemberType NoteProperty
    
                                                Add-Member `
                                                        -InputObject $newObject `
                                                        -Name PWNeverExpires `
                                                        -Value ($user | Select-Object PasswordNeverExpires) `
                                                        -MemberType NoteProperty

                                            $newObject
                                            <#$newObject.SAMAccountName
                                            $newObject.Name
                                            $newObject.MustChangePWAtNextLogon
                                            $newObject.CanChangePW
                                            $newObject.PWNeverExpires#>
                                    }
                                    }                                         
                                    Catch
                                    {
                                        Write-Output "ERROR"
                                        Continue
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