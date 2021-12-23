#Directories.
$MainDir = '../main_programs'
$TempDir = '../temp'

#Variables.
$Main = "$MainDir/report_02_01.f90"
$Makefile = "$MainDir/Makefile"

#GFortran activation.
$GFortran = "~/posh-scripts/mingw-on.ps1"
if (Test-Path -Path $GFortran) {& $GFortran}

foreach ($i in 1..4) {
    $Src = "$TempDir/temp$i.f90"
    $Exe = $Src -replace 'f90', 'exe'
    $Mkf = $Src -replace 'f90', 'mk'

    #Integrator.
    if ($i -lt 3) {$Int = 'Velocity Verlet'} else {$Int = 'Euler'}
    #Time increment.
    if ($i % 2 -eq 0) {$t = 3} else {$t = 4}

    #Temporary Makefile.
    (Get-Content -Path $Makefile) -replace 'filename', $Src |
        Out-File -FilePath $Mkf -Encoding ascii

    #Temporary Main.
    (Get-Content -Path $Main) `
        -replace '(?<=thermodynamics_01_)\d+', "0$i" `
        -replace '(?<=seed = ).*$', "$i" `
        -replace "(?<=integrator = ')[\w\s]+", "$Int" `
        -replace '(?<=dt = 1.0d-)\d', "$t" |
            Out-File -FilePath $Src -Encoding ascii

    #Simultaneous execution.
    Start-Process PowerShell -ArgumentList `
        "make -f $Mkf; $Exe; Remove-Item -Path $TempDir/temp$i*"
}
