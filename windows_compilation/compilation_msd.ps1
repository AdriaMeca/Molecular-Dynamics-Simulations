#Directories.
$MainDir = '../main_programs'
$TempDir = '../temp'

#Variables.
$Main = "$MainDir/mean_square_displacement.f90"
$Makefile = "$MainDir/Makefile"

#GFortran activation.
$GFortran = "~/posh-scripts/mingw-on.ps1"
if (Test-Path -Path $GFortran) {& $GFortran}

foreach ($i in 0..4) {
    $Src = "$TempDir/temp$i.f90"
    $Exe = $Src -replace 'f90', 'exe'
    $Mkf = $Src -replace 'f90', 'mk'

    #Temporary Makefile.
    (Get-Content -Path $Makefile) -replace 'filename', $Src |
        Out-File -FilePath $Mkf -Encoding ascii

    #Temporary Main.
    (Get-Content -Path $Main) `
        -replace '(?<=msd_)\d+', "0$i" `
        -replace '(?<=seed = ).*$', "$i" |
            Out-File -FilePath $Src -Encoding ascii

    #Simultaneous execution.
    Start-Process PowerShell -ArgumentList `
        "make -f $Mkf; $Exe; Remove-Item -Path $TempDir/temp$i*"
}
