#!/usr/bin/env pwsh

$env:COMPOSE_CONVERT_WINDOWS_PATHS = 1

function WorkdirToCompose {
    Set-Location $PSScriptRoot
}

function Crash {
    Write-Error $args.Get(0)
    exit $args.Get(1)
}

if ($args.Length -eq 0) {
    WorkdirToCompose
    docker compose run pyoplm
    exit 0
}

if ($args.Get(0) -eq "add") {
    $newArgs = [System.Collections.ArrayList]@()
    $src_file = ''
    for ($i = 1; $i -lt $args.Length; $i++) {
        if ($args.Get($i).ToString().Substring(0, 1) -eq "-") {
            $newArgs.Add($args.Get($i))
        }
        elseif (Test-Path $args.Get($i)) {
            $src_file = [IO.Path]::GetFullPath($args.Get($i))
        }
        else {
            Crash "Unknown parameter $($args.Get($i)), not an existing file" 2
        }
    }

    WorkdirToCompose
    if ($src_file -eq '') {
        docker compose run pyoplm add @newArgs
    }
    else {
        $filename = Split-Path $src_file -Leaf
        $mounts = [System.Collections.ArrayList]@()
        $mounts.Add(("-v", "${src_file}:/$filename"))
        if ($filename -match "\.[cC][uU][eE]$")
        {
            Select-String -path $src_file -pattern '\"(.*.bin)\"' |
                ForEach-Object {
                    $bin_src = Join-Path $(Split-Path -Path $src_file) $_.Matches[0].Groups[1]
                    $escaped_path = [WildcardPattern]::Escape($bin_src)

                    if (Test-Path $escaped_path){
                        $mounts.Add(("-v", "${bin_src}:/$($_.Matches[0].Groups[1])"))
                    } else {
                        Crash "Bin file $bin_src listed in the Cue file $filename does not exist" 3
                    }

                }
        }

        docker compose run @mounts pyoplm add @newArgs "/$filename"
    }
}
else {
    WorkdirToCompose
    docker compose run pyoplm @args
}
docker container rm $(docker container ls -a --filter="name=pyoplm-run" --format="{{.ID}}") | Out-Null
