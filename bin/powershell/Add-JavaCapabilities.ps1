[CmdletBinding()]
param()

# Define the JRE/JDK key names.
$jre6KeyName = "Software\JavaSoft\Java Runtime Environment\1.6"
$jre7KeyName = "Software\JavaSoft\Java Runtime Environment\1.7"
$jre8KeyName = "Software\JavaSoft\Java Runtime Environment\1.8"
$jdk6KeyName = "Software\JavaSoft\Java Development Kit\1.6"
$jdk7KeyName = "Software\JavaSoft\Java Development Kit\1.7"
$jdk8KeyName = "Software\JavaSoft\Java Development Kit\1.8"

# JRE/JDK keys for major version >= 9
$jdk9AndGreaterNameOracle = "Software\JavaSoft\JDK"
$jre9AndGreaterNameOracle = "Software\JavaSoft\JRE"
$jre9AndGreaterName = "Software\JavaSoft\Java Runtime Environment"
$jdk9AndGreaterName = "Software\JavaSoft\Java Development Kit"
$minimumMajorVersion9 = 9

# JRE/JDK keys for AdoptOpenJDK
$jdk9AndGreaterNameAdoptOpenJDK = "Software\AdoptOpenJDK\JDK"
$jdk9AndGreaterNameAdoptOpenJRE = "Software\AdoptOpenJDK\JRE"

# These keys required for several previous versions of AdoptOpenJDK that were published under the name Eclipse Foundation
$jdk9AndGreaterNameAdoptOpenJDKEclipseFoundation = "Software\Eclipse Foundation\JDK"
$jdk9AndGreaterNameAdoptOpenJREEclipseFoundation = "Software\Eclipse Foundation\JRE"

# These keys required for latest versions of AdoptOpenJDK since they started to publish under Eclipse Adoptium name from 22th October 2021 https://blog.adoptopenjdk.net/2021/03/transition-to-eclipse-an-update/ 
$jdk9AndGreaterNameAdoptOpenJDKEclipseAdoptium = "Software\Eclipse Adoptium\JDK"
$jdk9AndGreaterNameAdoptOpenJREEclipseAdoptium = "Software\Eclipse Adoptium\JRE"

# JRE/JDK keys for AdoptOpenJDK with openj9 runtime
$jdk9AndGreaterNameAdoptOpenJDKSemeru = "Software\Semeru\JDK"
$jdk9AndGreaterNameAdoptOpenJRESemeru = "Software\Semeru\JRE"

# JVM subdirectories for AdoptOpenJDK, since it could be ditributed with two different JVM versions, which are located in different subdirectories inside version directory
$jvmHotSpot = "hotspot\MSI"
$jvmOpenj9 = "openj9\MSI"

# Check for JRE.
$latestJre = $null
$null = Add-CapabilityFromRegistry -Name 'java_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JRE >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JRE in JavaSoft
if (-not $latestJre) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJREEclipseAdoptium -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJREEclipseFoundation -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRESemeru -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJre) {
    # Favor x64.
    Write-Capability -Name 'java' -Value $latestJre
}

# Check for JDK.
$latestJdk = $null
$null = Add-CapabilityFromRegistry -Name 'jdk_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JDK >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JDK in JavaSoft
if (-not $latestJdk) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKEclipseAdoptium -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKEclipseFoundation -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKSemeru -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJdk) {
    # Favor x64.
    Write-Capability -Name 'jdk' -Value $latestJdk

    if (!($latestJre)) {
        Write-Capability -Name 'java' -Value $latestJdk
    }
}

# SIG # Begin signature block
# MIIoLQYJKoZIhvcNAQcCoIIoHjCCKBoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBLTDBXOq2L2qu5
# EMVq1eURFS7cpBgTWmK5DdpGpsi0LKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIP1r26ja0Xd+Wr2Ntrtb3cY5
# M07/W1VGK1GBi1k59xN2MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEADEXniKOdILDY0tnD8350qPvEdZDAoP8IzZQf5H8TQsk6VFm/7p+Fxyk9
# GcHRPbZ41QxkNhUX+BbSaIUuOS8o1rbFINyuMxB7MdbP0DaFXYdBGzjwT7ncscsY
# raE/8GIoCWO5M3Q9z6bX0agj+RZVaRlagUau6jbGHlpU+gqrVDB+XX7CMdhCnPky
# dPyX90rItCSIdiRnFGk9qlGgk2/+7IcbhwW/1m3t/pd2b4P8rs5hmcYNntir3JR1
# KJojheZSdgsHGI8RXWHLs/Hffm77DOZ6sJGTcUQScx3fxdAPG4XXC5MNPoJFHrXh
# cZnq62Gfvu3PA1BZCx8dGi13qjDVHqGCF5cwgheTBgorBgEEAYI3AwMBMYIXgzCC
# F38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCA4EHt5ETIXvO34/0QMF+MSH0GxtIbF6XPGAHXMfKaSuAIGZc5S1brJ
# GBMyMDI0MDIyODEzMzgxNi42OTRaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzMwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHtMIIHIDCCBQigAwIBAgITMwAAAebZQp7qAPh94QABAAAB5jANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEyMDYxODQ1
# MTVaFw0yNTAzMDUxODQ1MTVaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzMwMy0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC9vph84tgluEzm/wpNKlAjcElGzflvKADZ1D+2d/ie
# YYEtF2HKMrKGFDOLpLWWG5DEyiKblYKrE2nt540OGu35Zx0gXJBE0zWanZEAjCjt
# 4eGBi+uakZsk70zHTQHHyfP+B3m2BSSNFPhgsVIPp6vo/9t6OeNezIwX5E5+VwEG
# 37nZgEexQF2fQZYbxQ1AauqDvRdXsSpK1dh1UBt9EaMszuucaR5nMwQN6sDjG99F
# zdK9Atzbn4SmlsoLUtRAh/768sKd0Y1hMmKVHwIX8/4JuURUBRZ0JWu0NYQBp8kh
# ku18Q8CAQ500tFB7VH3pD8zoA4lcA7JkxTGoPKrufm+lRZAA4iMgbcLZ2P/xSdnK
# FxU8vL31RoNlZJiGL5MqTXvvyBLz+MRP4En9Nye1N8x/lJD1stdNo5wJG+mgXsE/
# zfzg2GaVqQczFHg0Nl8bpIqnNFUReQRq3C1jVYMCScegNzHeYtw5OmZ/7eVnRmjX
# lCsLvdsxOzc1YVn6nZLkQD5y31HYrB9iIHuswhaMv2hJNNjVndkpWy934PIZuWTM
# k360kjXPFwl2Wv1Tzm9tOrCq8+l408KIL6J+efoGNkR8YB3M+u1tYeVDO/TcObGH
# xaGFB6QZxAUpnfB5N/MmBNxMOqzG1N8QiwW8gtjjMJiFBf6iYYrCjtRwF7IPdQLF
# tQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFOUEMXntN54+11ZM+Qu7Q5rg3Fc9MB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBhbuogTapRsuwSkaFMQ6dyu8ZCYUpWQ8iI
# rbi40tU2hK6pHgu0hj0z/9zFRRx5DfhukjvbjA/dS5VYfxz1EIbPlt897MJ2sBGO
# 2YLYwYelfJpDwbB0XS9Zkrqpzq6X/lmDQDn3G5vcYpYQCJ55LLvyFlJ195AVo4Wy
# 8UX5p7g9W3MgNHQMpM+EV64+cszj4Ho5aQmeKGtKy7w72eRY/vWDuptrvzruFNmK
# CIt12UcA5BOsXp1Ptkjx2yRsCj77DSml0zVYjqW/ISWkrGjyeVJ+khzctxaLkklV
# wCxigokD6fkWby0hCEKTOTPMzhugPIAcxcHsR2sx01YRa9pH2zvddsuBEfSFG6Cj
# 0QSvEZ/M9mJ+h4miaQSR7AEbVGDbyRKkYn80S+3AmRlh3ZOe+BFqJ57OXdeIDSHb
# vHzJ7oTqG896l3eUhPsZg69fNgxTxlvRNmRE/+61Yj7Z1uB0XYQP60rsMLdTlVYE
# yZUl5MLTL5LvqFozZlS2Xoji4BEP6ddVTzmHJ4odOZMWTTeQ0IwnWG98vWv/roPe
# gCr1G61FVrdXLE3AXIft4ZN4ZkDTnoAhPw7DZNPRlSW4TbVj/Lw0XvnLYNwMUA9o
# uY/wx9teTaJ8vTkbgYyaOYKFz6rNRXZ4af6e3IXwMCffCaspKUXC72YMu5W8L/zy
# TxsNUEgBbTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNQ
# MIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjMzMDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQDi
# WNBeFJ9jvaErN64D1G86eL0mu6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6YlLvTAiGA8yMDI0MDIyODA2MDU0
# OVoYDzIwMjQwMjI5MDYwNTQ5WjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDpiUu9
# AgEAMAoCAQACAgOPAgH/MAcCAQACAhL2MAoCBQDpip09AgEAMDYGCisGAQQBhFkK
# BAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJ
# KoZIhvcNAQELBQADggEBAJAwqpTAEVVgXLO1vShMQNs7rzaiDkUUWCQApsEOFDKy
# NvCmFitnrm+evLnbvD0TIqe1P6FokZ451t8Xdr7kycmvMNTW8h81xaetal2QpEXu
# nCgFGU+brBz4+qCIZo5aG2jPZMPaIW01EuIePQncGAXw4i6iyrLoV+sRubJdmOy8
# AgfGFNAEsKVc0gOaWiWyqli+rT8ewF3amXJor5/junbkuGD9kBotVbhORYuD9F3e
# QvQLLfEDSkXu3Dr9JmOX864KTRtPksh32fPQfgjxdLjs2jI4GURyGfHyPBxsu+16
# bX2jf3Jc8zmUfAjmlSbCryqlYZR3ZVqrz2jDJM1guuIxggQNMIIECQIBATCBkzB8
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
# aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAebZQp7qAPh94QABAAAB
# 5jANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
# MC8GCSqGSIb3DQEJBDEiBCB2zdMCqVGavizww45zDrNlhqRmOJlONricVkQ8cDLg
# mTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIM+7o4aoHrMJaG8gnLO1q16h
# IYcRnoy6FnOCbnSD0sZZMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAHm2UKe6gD4feEAAQAAAeYwIgQg6IPmAwK+UyhstGPNls1M7ZS7
# QElV6fBfFPl6Rt5ukBswDQYJKoZIhvcNAQELBQAEggIAMTm4HRyBP2iZAIcazy1G
# RAVeg/8R/e1RjByibKSEshJQtloQS1Z0txsZtwcorXhw2/SxhiXjcwzrN1bY98yR
# Nfym3mEqXkRmyaIEUhiyVYmvaFSVtfRJi8oyABmVlaoJ643oyXzJLnlY/GwpbV3a
# mN/l0g/nBqX1Y2oBze4RTBMNU84LHzGXYYJFdANWki/1tNHHvYSvUm02HNEqpk1g
# 64f/6srA3eQ56qDM4QkVVru/OhHMCbCcW+oI+1H03AgwQrQNbavMulD94KfpduIM
# aEnxg6g1/bDFdVdcCg+1F5Xc6+Tzh9yNqIjkLtNjbNpLZagifdG7HX6nC2IzCesb
# CATMuahhz2EWO7nF6v0uJrqSV8ISiaAxpQaaZhYi5eagiPtDq8edER7kl8iIjK5g
# e7L/IFZRrscFfVXOY4ha4Zot3LJLZrgLCKgW8Bf+tH7wMtFWvdLeU/QykZGn0J+X
# +v9dSDUVMvl0VzWOZadofWw+qM80yh7M4JqE1fmaS55QyBdkaOTujrM0upcbjelQ
# xURch97uf+FgX8b+4tWmDuztTMow7fNMH2pVYU6YgK0Zefww7FOOxoPQq+me5Yf+
# O2UlZ+ZjewYknozEfFHXyoE00oUXzLfpWHoW7MO0L8aFO1iBJIFG8N02ZbAmuyW8
# 9xfBQ8nyHTkQm/jwO2FhhB8=
# SIG # End signature block
