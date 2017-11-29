[cmdletbinding(
            DefaultParameterSetName="UserNameSet"
                )]

param(

 #**********************P5*********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [string] $Server
        ,
        [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $path
        ,
        #**********************P6*********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$false
                    )]

        [PSCredential] $Credential
        ,
      #********************P2**********************
        [Parameter(
                    ParameterSetName="UserNameSet",
                    Mandatory=$true, # $true,
                    valueFromPipeLine=$true
                    )]

        [string[]] $UserName 

         ,
        #********************P3**********************
        [Parameter(
                    ParameterSetName="FilterSet",
                    Mandatory=$true,
                    valueFromPipeLine=$false
                    )]

        [string] $Filter

         ,
        #********************P1**********************

        [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [bool] $Confirm=$True


       )

    BEGIN
    {
        Write-Verbose "BEGIN starting..."
        Write-output "BEGIN"
        Write-Verbose "BEGIN finished..."

        #[String[] ] $removeList = ""
        #$removeCounter = 0
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
                                                  $removeUser = (
                                                                    Get-ADUser `
                                                                                -Filter { Name -eq $userName } | Where-Object DistinguishedName -like "*$path*" `
                                                                                -Server $Server `
                                                                                -Credential $Credential `
                                                                                -ErrorAction SilentlyContinue                                                                                                                                                                                                                                                                                           
                                                                )

                                                    #$removeList[$removeCounter] = $userName


            
                                                        if($removeUser)
                                                        {
                                                                             
                                                              Remove-ADUser `
                                                                                -Identity $removeUser `                                                                        
                                                                                -Server $Server `
                                                                                -Credential $Credential `
                                                                                -Confirm:$Confirm `
                                                                                -ErrorAction SilentlyContinue

                                                                                $removeCounter++

                                                             Write-output "REMOVING User USING userName " . $($removeUser).Name
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
                                         $removeUser = (
                                                        Get-ADUser `
                                                        -Server $Server `
                                                        -Credential $Credential `
                                                        -Filter $Filter | Where-Object DistinguishedName -like "*$path*" `
                                                        -ErrorAction SilentlyContinue
                                                       )
                                        }
                                        Catch
                                        {
                                            Write-Output "ERROR"
                                            Continue
                                        }
                                        
                                        
                                        foreach($removeFilterUser in $removeUser)
                                        {

                                            Try
                                            { 
                                                    <#$isUser = (Get-ADUser `
                                                                        -Identity $removeFilterUser `
                                                                        -Filter * `
                                                                        -Server $pServer `
                                                                        -Credential $pCredential)#>
            
                                                            if($removeFilterUser)
                                                            {

                                                                  Remove-ADUser `
                                                                                    -Identity $removeFilterUser `
                                                                                    -Server $Server `
                                                                                    -Credential $Credential `
                                                                                    -Confirm:$Confirm `
                                                                                    -ErrorAction SilentlyContinue

                                                                 Write-output "REMOVING User USING Filter $($removeFilterUser).Name "
                                                            }
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