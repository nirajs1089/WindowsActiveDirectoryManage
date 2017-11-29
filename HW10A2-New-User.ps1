[cmdletbinding()]


param(

    #********************P1**********************
        [Parameter(
                    Mandatory=$false,
                    valueFromPipeLine=$false
                    )]

        [string] $Path

         ,
      #********************P2**********************
        [Parameter(
                    Mandatory=$True,
                    valueFromPipeLine=$True
                    )]

        [string[]] $UserName

         ,
        #********************P3**********************
        [Parameter(
                    Mandatory=$False,
                    valueFromPipeLine=$False
                    )]

        [string] $Prefix

         ,
        #********************P4**********************
        [Parameter(
                    Mandatory=$True, 
                    valueFromPipeLine=$False
                    )]

        [string] $Password

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
        Write-Output "************************NEW USER ACCOUNTS**************** "

        foreach($userName in $UserName)
        {          
            try
            {
            
            
          
                   #*************Split the Name **************
                    $firstName = $userName.split(" ")[0]
                    $lastName = $userName.split(" ")[($userName.split(" ").Count)-1]

                    #*************Extract the Part of First Name and Last Name **************
                    if(($lastName.Length -lt 4) -and ($firstName.Length -lt 2))
                                            {
                 $firstName = $firstName
                 $lastName = $lastName

            }
                    elseif($firstName.Length -lt 2)
                                            {
                   $firstName = $firstName
                   $lastName = $lastName.Substring(0,4)
            }
                    elseif($lastName.Length -lt 4)
                                            {
                   $firstName = $firstName.Substring(0,2)
                   $lastName = $lastName
            }
                    else
                                            {           
                    $firstName = $firstName.Substring(0,2)
                    $lastName = $lastName.Substring(0,4)
            }


                    $FinaluserName = $lastName + $firstName

                    $FinaluserName = $Prefix + $FinaluserName


                                            $isUser = (Get-ADUser `
                                                                -filter { Name -eq $FinaluserName} `
                                                                -Server $Server `
                                                                -Credential $Credential `
                                                                -ErrorAction SilentlyContinue).Count
            
                        if(!$isUser)
                                                                                                                                                                                                                {
                    
                        if(!$Path)
                        {
                            New-ADUser `
                                     -Name $FinaluserName `                                                                                                         
                                     -AccountPassword (convertto-securestring $Password -asplaintext -force) `
                                     -Server $Server `
                                     -Credential $Credential `
                                     -Enabled $True `
                                     -ErrorAction SilentlyContinue
                        }
                        elseif($Path)
                        {
                            New-ADUser `
                                     -Path $Path `
                                     -Name $FinaluserName `
                                     -AccountPassword (convertto-securestring $Password -asplaintext -force) `
                                     -Server $Server `
                                     -Credential $Credential `
                                     -Enabled $True `
                                     -ErrorAction SilentlyContinue
                        }
                    
                    Write-Output "User $($FinaluserName)  Created"

                  } 
            }      
            catch
            {
                    Write-Output "error"
                    Continue
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