Configuration WindowsServer_config
{
    param
    (
        [Parameter()]
        [AllowNull()]
        [string]
        $TechnologyVersion,

        [Parameter()]
        [AllowNull()]
        [string]
        $TechnologyRole,

        [Parameter(Mandatory = $true)]
        [version]
        $StigVersion,

        [Parameter()]
        [string[]]
        $SkipRule,

        [Parameter()]
        [string[]]
        $SkipRuleType,

        [Parameter()]
        [string[]]
        $Exception,

        [Parameter()]
        [string[]]
        $OrgSettings,

        [Parameter()]
        [AllowNull()]
        [string]
        $ForestName,

        [Parameter()]
        [AllowNull()]
        [string]
        $DomainName
    )

    Import-DscResource -ModuleName PowerStig

    Node localhost
    {
        & ([scriptblock]::Create("
            WindowsServer BaseLineSettings
            {
                OsVersion   = '$TechnologyVersion'
                OsRole      = '$TechnologyRole'
                StigVersion = '$StigVersion'
                ForestName  = '$ForestName'
                DomainName  = '$DomainName'
                $(if ($null -ne $OrgSettings)
                {
                    "Orgsettings = '$OrgSettings'"
                })
                $(if ($null -ne $Exception)
                {
                    "Exception = @{$( ($Exception | ForEach-Object {"'$PSItem' = '1234567'"}) -join "`n" )}"
                })
                $(if ($null -ne $SkipRule)
                {
                    "SkipRule = @($( ($SkipRule | ForEach-Object {"'$PSItem'"}) -join ',' ))`n"
                }
                if ($null -ne $SkipRuleType)
                {
                    "SkipRuleType = @($( ($SkipRuleType | ForEach-Object {"'$PSItem'"}) -join ',' ))`n"
                })
            }")
        )

        <#
            This is a little hacky because the scriptblock "flattens" the array of rules to skip.
            This just rebuilds the array text in the scriptblock.
        #>
    }
}
