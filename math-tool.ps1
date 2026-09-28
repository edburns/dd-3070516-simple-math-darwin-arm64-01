[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N,

    [ValidateSet('fibonacci', 'factorial')]
    [string]$Operation = 'fibonacci'
)

function Get-Fibonacci {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [System.Numerics.BigInteger]$previous = 0
    [System.Numerics.BigInteger]$current = 1
    for ($index = 0; $index -lt $N; $index++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }

    if ($previous -le [long]::MaxValue) {
        return [long]$previous
    }

    return $previous
}

function Get-Factorial {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [System.Numerics.BigInteger]$result = 1
    for ($factor = 2; $factor -le $N; $factor++) {
        $result *= $factor
    }

    if ($result -le [long]::MaxValue) {
        return [long]$result
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') {
    if ($Operation -eq 'factorial') {
        $value = Get-Factorial -N $N
        Write-Output "Factorial($N) = $value"
    }
    else {
        $value = Get-Fibonacci -N $N
        Write-Output "Fibonacci($N) = $value"
    }
}
