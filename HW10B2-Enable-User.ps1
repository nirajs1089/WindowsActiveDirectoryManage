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
        #********************P3**********************
        [Parameter(
                    ParameterSetName="FilterSet",
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter

         ,
        #********************P4**********************
        [Parameter(
                    Mandatory=$false, # $true,
                    valueFromPipeLine=$false
                    )]

        [bool] $Confirm=$True

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

                                foreach($userName in $UserName)
                                {
                                    Try
                                    {
                                          $enableUser = (
                                                            Get-ADUser `
                                                            -Server $Server `
                                                            -Credential $Credential `
                                                            -Filter { Name -eq $userName } | Where-Object DistinguishedName -like "*$path*" `
                                                            -ErrorAction SilentlyContinue
                                                        )
                    
                                         foreach($user in $enableUser)
                                         {                     
          
                                                  Enable-ADAccount `
                                                                    -Identity $user `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Confirm:$Confirm `
                                                                    -ErrorAction SilentlyContinue
                                        
                                                $isEnable = (
                                                                    Get-ADUser `
                                                                    -Server $Server `
                                                                    -Credential $Credential `
                                                                    -Identity $user `
                                                                    -ErrorAction SilentlyContinue
                                                                ).Enabled
                                        
                                                if($isEnable)
                                                {
                                                  $user
                                                }
                                         }

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
                                        $enableUser = (
                                                        Get-ADUser `
                                                        -Server $Server `
                                                        -Credential $Credential `
                                                        -Filter $Filter | Where-Object DistinguishedName -like "*$path*"`
                                                        -ErrorAction SilentlyContinue 
                                                       )
                                         
                                         foreach($user in $enableUser)
                                         {
                                            
                                                      Enable-ADAccount `
                                                                        -Identity $user `
                                                                        -Server $Server `
                                                                        -Credential $Credential `
                                                                        -Confirm:$Confirm `
                                                                        -ErrorAction SilentlyContinue

                                                    $isEnable = (
                                                                        Get-ADUser `
                                                                        -Server $Server `
                                                                        -Credential $Credential `
                                                                        -Identity $user `
                                                                        -ErrorAction SilentlyContinue
                                                                    ).Enabled
                                        
                                                    if($isEnable)
                                                    {
                                                      $user
                                                    }
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