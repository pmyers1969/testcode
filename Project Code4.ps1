###################################################
# Create virtual machine

# ISE is just awesome
ise

###################################################
# 0. Azure Account Details

Add-AzureAccount
$subName = "MPN Gold Competency"
Select-AzureSubscription $subName

# Azure account details automatically set
$subID = Get-AzureSubscription -Current | %{ $_.SubscriptionId } 


###################################################
# 1. Input information

# variables to storage accounts
$location = "Australia SouthEast" #e.g. North Europe, West Europe, etc.
$storageAccount = "pmstorage999"
$defaultContainer = "vhds"
$affinityGrp = "PaulMAffinityGroup"
$instanceSize = "Small" #Small, Large, etc.

# variables to VM
$vmName = "pmvm99"
$adminLogin = "toonadmin"
$adminPasswd = "hassle123!"


###################################################
# 2. Provision storage

# a. Create affinity group
# New-AzureAffinityGroup -Name $affinityGrp -Location $location

# b. Provision storage account
#New-AzureStorageAccount -StorageAccountName $storageAccount -AffinityGroup $affinityGrp
# dont need New-AzureStorageAccount -StorageAccountName $storageAccount -Location $location
# dont need Set-AzureStorageAccount -StorageAccountName $storageAccount -GeoReplicationEnabled $false

# c. Set storage account as default one, otherwise you will not be able to build your VM
Set-AzureSubscription -SubscriptionName $subName -CurrentStorageAccount $storageAccount

# d. Check if the storage account is set as the default one
Get-AzureSubscription -Current


###################################################
# 3. Build VM

# a. Pick VM image
$vmImage = Get-AzureVMImage `
    | Where-Object -Property ImageFamily -ilike "Windows Server 2012 R2*" `
    | Sort-Object -Descending -Property PublishedDate `
    | Select-Object -First(1)

# automatically set for you: credentials to VM
$vmCreds = New-Object System.Management.Automation.PSCredential($adminLogin,($adminPasswd `
    | ConvertTo-SecureString -AsPlainText -Force))

# b. Build VM
#New-AzureQuickVM -ImageName $VMImage.ImageName -Windows -Name $VMName -ServiceName $VMName `
# -AdminUsername $adminLogin -Password $adminPasswd -AffinityGroup $affinityGrp
New-AzureQuickVM -ImageName $vmImage.ImageName -Windows -Name $vmName -ServiceName $vmName `
    -AdminUsername $adminLogin -Password $adminPasswd -Location $location -InstanceSize $instanceSize


############################################### 
# 4. Get status, properties, etc. 

# a. Check status
Get-AzureVM -Name $vmName -ServiceName $vmName

# b. Stop, start or restart the VM
#Stop-AzureVM -Name $vmName -ServiceName $vmName
#Start-AzureVM -Name $vmName -ServiceName $vmName
#Restart-AzureVM -Name $vmName -ServiceName $vmName

# c. Clean up
#Remove-AzureVM -ServiceName $vmName -Name $vmName -DeleteVHD


############################################### 
# 5. clean up 

# a. Remove VM & cloud service
#Remove-AzureVM -Name $vmName -ServiceName $vmName
#Remove-AzureVM -ServiceName $vmName

# b. Remove storage account
#Remove-AzureStorageAccount -StorageAccountName $storageAccount 