codeunit 50001 "LGX ZMO Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        AppAreaMgmt: Codeunit "LGX ZMO App. Area Mgmt";
    begin
        if not AppAreaMgmt.IsAreaEnabled() then
            AppAreaMgmt.EnableAppAreaExtension();
    end;
}