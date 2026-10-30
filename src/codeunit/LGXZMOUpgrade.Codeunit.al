codeunit 50002 "LGX ZMO Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        AppAreaMgmt: Codeunit "LGX ZMO App. Area Mgmt";
    begin
        if not AppAreaMgmt.IsAreaEnabled() then
            AppAreaMgmt.EnableAppAreaExtension();

        NavApp.RestoreArchiveData(Database::Item);
        NavApp.RestoreArchiveData(Database::"Sales & Receivables Setup");

        NavApp.DeleteArchiveData(Database::Item);
        NavApp.DeleteArchiveData(Database::"Sales & Receivables Setup");
    end;
}