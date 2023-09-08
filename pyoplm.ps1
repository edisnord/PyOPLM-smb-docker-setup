#!/usr/bin/env pwsh

function WorkdirToCompose
{
    Set-Location $PSScriptRoot
}

function Crash
{
    Write-Error $args.Get(0)
    exit $args.Get(1)
}

if ($args.Get(0) -eq "add")
{
    $newArgs = [System.Collections.ArrayList]@()
    $src_file = ''
    for ($i=1; $i -lt $args.Length; $i++)
    {
        if ($args.Get($i).ToString().Substring(0, 1) -eq "-")
        {
            $newArgs.Add($args.Get($i))
        } elseif (Test-Path $args.Get($i)) {
            $src_file = [IO.Path]::GetFullPath($args.Get($i))
        } else {
            Crash "Unknown parameter $($args.Get($i)), not an existing file" 2
        }
    }

    WorkdirToCompose
    if ($src_file -eq '') {
        docker compose run pyoplm add @newArgs
    } else {
        $filename = Split-Path $src_file -Leaf
        docker compose run -v "${src_file}:/$filename" pyoplm add @newArgs "/$filename"
    }
} else
{
    WorkdirToCompose
    docker compose run pyoplm @args
}
