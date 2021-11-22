#EmployeeMasterData_1u
#EmployeeMasterData_2w
#EmployeeMasterData_3h
#EmployeeMasterData2  test

$dcn="sembutil.corp"
$msg1="Sembutil Exporting...."
$msg2="Record Updated...."
$Credentials = Get-AutomationPSCredential -Name 'ADsync' 
$fname="EmployeeMasterData_1.csv"
#$fname="EmployeeMasterData_2.csv"
#$fname="EmployeeMasterData_3.csv"

#Test
#$fname="EmployeeMasterData2.csv"
$counter0=0
Write-Host "AD record Exporting ..." $user.Email -BackgroundColor "Magenta" -ForegroundColor "Black"
$msg1
#Import-CSV \\webprddb.sembapp.corp\D$\ADUserSync\EmployeeMasterData2.csv |ForEach-Object{
Import-CSV \\webprddb.sembapp.corp\D$\ADUserSync\$fname |ForEach-Object{
       $counter0++
Write-Host "No of record read.:" $counter0 -BackgroundColor "Yellow" -ForegroundColor "Black"
		Get-ADUser -Filter  "UserPrincipalName -eq '$($_.loginid)'" -server $dcn  -Properties * -ErrorAction SilentlyContinue } |
	Select-Object UserPrincipalName,name,mail,mailnickname,mobile, Company,title ,streetaddress,postalcode,country,department,samaccountname, description, office, homeDirectory,ExtensionAttribute1,ExtensionAttribute2,ExtensionAttribute3,ExtensionAttribute4,ExtensionAttribute5,ExtensionAttribute6,ExtensionAttribute7,ExtensionAttribute8,ExtensionAttribute9,ExtensionAttribute10,ExtensionAttribute11,ExtensionAttribute12,ExtensionAttribute13,ExtensionAttribute14,manager,co,countrycode  | Export-Csv C:\CommonDB\Export\$((Get-Date).ToString("yyyy-MM-dd_HHmmss"))_aexportdata$dcn.csv -NoTypeInformation
$counter1 = 0
$counter2 = 0


###########################
# test $USERS = Import-CSV C:\temp\EmployeeMasterData2.csv -delimiter ','
# sembwh EmployeeMasterData_2wh
#$USERS = Import-CSV \\webprddb.sembapp.corp\D$\ADUserSync\EmployeeMasterData2.csv -delimiter ','
$USERS = Import-CSV \\webprddb.sembapp.corp\D$\ADUserSync\$fname -delimiter ','

foreach ($user in $USERS){

if($ADUser = Get-ADUser -Filter  "UserPrincipalName -eq '$($user.loginid)'" -server $dcn -pr * -credential $Credentials -ErrorAction SilentlyContinue)
	{
        $counter1++
Write-Host "No of record updated:" $counter1
       		$ADUser.samAccountName
        	$user.extendedattribute2
            	$user.country
                $ADUser.country 
		# set up a Splatting Hashtable for the Set-ADUser cmdlet
    $replace= @{}
       # $userParams = @{
       
	      # Purple exclude in sync 
		#Title = $User.JobTitle 
		# email	

		if( $User.Department)
		{
			$replace['Department'] = $User.Department
		}
		
	# Green
		if( $user.Company)
		{
			$replace['Company']   = $User.Company
		}

		if( $User.streetaddress)
		{
			$replace['streetaddress']  =$User.streetaddress
		}

		if($User.postalcode)
		{
			$replace['postalcode'] =$User.postalcode
		}
		if($User.sapusername)
		{
			$replace['ExtensionAttribute1'] =$User.sapusername
		}
		if($User.employeeno )
		{
			$replace['ExtensionAttribute2'] =$User.employeeno 
		}

		#Country	@{c="BE";co="belgium";countrycode=59}
		if($User.country)
		{
		Write-Host "Country : "
		$User.isoCountryCode
		$User.country
		$User.isoCountryNumericCode
			$replace['c']=$User.isoCountryCode
			$replace['co']=$User.country
       			$replace['countrycode']=$User.isoCountryNumericCode
		}

#co
	#yellow
	if($user.Group )
	{
		$replace['ExtensionAttribute3'] =  $user.Group
	}
		
	if($user.Division )
	{
		$replace['ExtensionAttribute4'] =  $user.Division
	}	
		
	if($user.ctitle )
	{	
		$replace['ExtensionAttribute5'] =  $user.ctitle # commercial title english

	}
Write-Host "data -- "$user.chcompany
#$chc =$user.chcompany 
#$chc+=" "
	if( $user.chdisplayname  ) { $replace['extensionAttribute6'] =  $user.chdisplayname }
	
 	if( $user.chcompany  )   { $replace['extensionAttribute7'] =$user.chcompany } # Chinese company name
	
	if( $user.chgroup  )    { $replace['ExtensionAttribute8'] =  $user.chgroup } 
	if( $user.chdivision )  { $replace['ExtensionAttribute9'] =  $user.chdivision }
	if( $user.chdepartment ){ $replace['ExtensionAttribute10'] = $user.chdepartment }
	if( $user.chctitle     ){ $replace['ExtensionAttribute11'] = $user.chctitle }  # Commercial title Chinese
	if( $user.chstreetaddress    ) { $replace['ExtensionAttribute12'] = $user.chstreetaddress  } # Address Chinese	
	if( $user.chcountry  ) { $replace['ExtensionAttribute13'] = $user.chcountry } # Address Chinese	
	#$d=$ADUser.DistinguishedName
	#$d
		#$replace['ExtensionAttribute14'] = $d

        #}param
        $ADUser | Set-ADUser -Replace $replace
		


        #Get-ADUser -identity  "testexchange"  | Set-ADUser - @userParams

        Write-Host "AD record updated... " $user.Email -BackgroundColor "Magenta"  
	$replace
#Set-ADUser $ADUser.samAccountName -Replace @{ExtensionAttribute2 = $user.extendedattribute2}
#$adUser | Set-ADUser -Replace @{ info = $User.Service; departmentNumber = $User.'Cost Centre' }
$msg2
    }
    else
	
    {Write-Host "User Could not found " $user.Email -BackgroundColor "Yellow" -ForegroundColor "Black" 
#yyyy-MM-dd_HHmmss
$counter2++
	$user.Email |out-file C:\CommonDB\Export\ausernotfound$dcn$((Get-Date).ToString("yyyy-MM-dd_HH")).txt -append
    }
  
}
'All Ad record Updated...' 
Write-Host "Total no of record updated: " $counter1 -BackgroundColor "Yellow" -ForegroundColor "Black" 
Write-Host "Total no of user not found: " $counter2 -BackgroundColor "Yellow" -ForegroundColor "red" 
