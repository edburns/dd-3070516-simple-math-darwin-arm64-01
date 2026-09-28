BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $scriptPath -N 0
}

Describe 'Get-Fibonacci' {
    It 'returns zero for N=0 without incidental output' {
        $result = @(Get-Fibonacci -N 0)

        $result.Count | Should -Be 1
        $result[0] | Should -Be 0
        $result[0].GetType().Name | Should -Be 'Int64'
    }

    It 'returns one for N=1' {
        Get-Fibonacci -N 1 | Should -Be 1
    }

    It 'returns the representative Fibonacci value for N=10' {
        Get-Fibonacci -N 10 | Should -Be 55
    }

    It 'returns an exact arbitrary-precision value for N=93' {
        $result = Get-Fibonacci -N 93

        $result | Should -Be ([System.Numerics.BigInteger]::Parse('12200160415121876738'))
        $result.GetType().Name | Should -Be 'BigInteger'
    }
}

Describe 'math-tool CLI' {
    It 'writes exactly one result line for N=<N>' -TestCases @(
        @{ N = 0; Expected = 0 }
        @{ N = 1; Expected = 1 }
        @{ N = 10; Expected = 55 }
        @{ N = 93; Expected = '12200160415121876738' }
    ) {
        $processStartInfo = [System.Diagnostics.ProcessStartInfo]::new()
        $processStartInfo.FileName = (Get-Command pwsh).Source
        $processStartInfo.UseShellExecute = $false
        $processStartInfo.RedirectStandardOutput = $true
        $processStartInfo.RedirectStandardError = $true
        [void]$processStartInfo.ArgumentList.Add('-NoLogo')
        [void]$processStartInfo.ArgumentList.Add('-NoProfile')
        [void]$processStartInfo.ArgumentList.Add('-File')
        [void]$processStartInfo.ArgumentList.Add($scriptPath)
        [void]$processStartInfo.ArgumentList.Add('-N')
        [void]$processStartInfo.ArgumentList.Add([string]$N)

        $process = [System.Diagnostics.Process]::new()
        $process.StartInfo = $processStartInfo
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $process.ExitCode | Should -Be 0
        $stderr | Should -Be ''
        $stdout | Should -Be "Fibonacci($N) = $Expected$([Environment]::NewLine)"
    }
}
