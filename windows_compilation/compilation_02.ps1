#Directories.
$MainDir = '../main_programs'
$TempDir = '../temp'

#Variables.
$Main = "$MainDir/report_02_02.f90"
$Makefile = "$MainDir/Makefile"

#GFortran activation.
$GFortran = "~/posh-scripts/mingw-on.ps1"
if (Test-Path -Path $GFortran) {& $GFortran}

foreach ($i in 2..8) {
    if ($i % 2 -eq 0) {
        $Src = "$TempDir/temp$i.f90"
        $Exe = $Src -replace 'f90', 'exe'
        $Mkf = $Src -replace 'f90', 'mk'

        #Temporary Makefile.
        (Get-Content -Path $Makefile) -replace 'filename', $Src |
            Out-File -FilePath $Mkf -Encoding ascii

        #Temporary Main.
        (Get-Content -Path $Main) `
            -replace '(?<=thermodynamics_02_)\d+', "0$i" `
            -replace '(?<=seed = ).*$', "$i" `
            -replace '(?<=rho = ).*$', "0.${i}d0" |
                Out-File -FilePath $Src -Encoding ascii

        #Simultaneous execution.
        Start-Process PowerShell -ArgumentList `
            "make -f $Mkf; $Exe; Remove-Item -Path $TempDir/temp$i*"
    }
}
