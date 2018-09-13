<#
    Constraints:
    Mininum length must be under 250 char.
    Working folder must contain files.
    File extensions must start with . and exactly 3 characters.
    Files only
    None recursive
    This script must be name shortenFile.ps1
#>

#region FUNCTIONS
function confirmThem{
    Param($newList)
    $newList.ForEach({[PSCustomObject]$_}) | Format-Table -AutoSize
    $confirm = Read-Host "Confirm by typing y?"
    $ans = if($confirm -eq 'y'){ $true} else{$false}
    return $ans
}

function renameThem{
    Param($newList)
    foreach($i in $newList){
        Rename-Item $i.Original $i.Rename
        Write-Host $i.Original "=>" $i.Rename
    }
    Write-Host ""
    Write-Host "-----Rename completed-----"
}

function verifyInputs{
    Param($minLength, $files)
    if($minLength -match "^[\d\.]+$" -eq $false){
        throw "Your minimum length is invalid."
    }

    if($minLength/1 -gt 250){
        throw "Your minimum length is too large."
    }
    if($files.Length -lt 1){
        throw "No files to rename"
    }
}

function cloneTrim{
    Param($source, $minLength)
    $tracker = @{} #tracks name uniqueness
    $newList = @() #will eventually produce the new name
    foreach($i in $source){
        if($i.Name -eq "shortenFile.ps1"){continue}
        #region sets checkable length
        $thisLength = $minLength;
        if ($i.Name.Length-4 -lt $minLength){
            $thisLength = $i.Name.Length - 4
        }
        #endregion

        $nextName = @{}; #next new name
        $subName = $i.Name.Substring(0, $thisLength)
        if($tracker.ContainsKey($subName) -eq $false){
            $dict = @{Name = $subName; Len = $thisLength}
            $tracker += @{$subName = "none"}
            $nextName = $dict
        }else{
            #Write-Host "already contains " $subName    
            $changed = changeName -source $source -subName $subName -Name $i.Name -minLength $thisLength -tracker $tracker
            #Write-Host "new name "$changed.Name
            $tracker += @{$changed.Name = "none"}
            $nextName = $changed
        }

        #each item is the new name and original name
        $newList += @{Original = $i.Name; Rename = $($nextName.Name + $i.Name.Substring($i.Name.Length-4, 4))}
    }
    return $newList
}

function changeName{
    Param($subName, $Name, $source, $minLength, $tracker)
    $current = $subName
    $currentLen = $minLength
    while($tracker.ContainsKey($current)){
        $currentLen++
        $current = $Name.Substring(0, $currentLen)
        #Write-Host "name changed"$current
    }
    return @{Name = $current; Len = $currentLen}
}

#endregion

#region MAIN

$minLength = Read-Host "What is the minimum length?" 
$filesOnly = gci . *.* | where { ! $_.PSIsContainer }
verifyInputs -minLength $minLength -files $filesOnly
$minLength = [int]$minLength
$files = $filesOnly | Select -Property Name
$tempList = cloneTrim -source $files -minLength $minLength

$tempList.ForEach({[PSCustomObject]$_}) | Format-Table -AutoSize
$confirm = Read-Host "Confirm by typing y?"
$ans = if($confirm -eq 'y'){ $true} else{$false}

if($ans){renameThem -newList $tempList}

#endregion

