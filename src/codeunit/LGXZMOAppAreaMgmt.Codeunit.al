codeunit 50003 "LGX ZMO App. Area Mgmt"
{
    procedure IsAreaEnabled(): Boolean
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then
            exit(ApplicationAreaSetup."LGX ZMO Functionality");
        exit(false);
    end;

    procedure EnableAppAreaExtension()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        ExperienceTierSetup: Record "Experience Tier Setup";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        // The extension will only work on Essentials or Premium
        if ExperienceTierSetup.Get(CompanyName()) then;
        if not ExperienceTierSetup.Essential and not ExperienceTierSetup.Premium then
            exit;

        if ApplicationAreaMgmtFacade.GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup, CompanyName()) then begin
            ApplicationAreaSetup."LGX ZMO Functionality" := true;
            ApplicationAreaSetup.Modify();

            ApplicationAreaMgmtFacade.SetupApplicationArea();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetBasicExperienceAppAreas', '', true, true)]
    local procedure RegisterExtensionOnGetBasicExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup")
    begin
        TempApplicationAreaSetup."LGX ZMO Functionality" := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetEssentialExperienceAppAreas', '', true, true)]
    local procedure RegisterExtensionOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup")
    begin
        TempApplicationAreaSetup."LGX ZMO Functionality" := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetPremiumExperienceAppAreas', '', true, true)]
    local procedure RegisterExtensionOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup")
    begin
        TempApplicationAreaSetup."LGX ZMO Functionality" := true;
    end;
}