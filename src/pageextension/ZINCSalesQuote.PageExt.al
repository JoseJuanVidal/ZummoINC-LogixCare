pageextension 50071 "ZINC Sales Quote" extends "Sales Quote"
{
    layout
    {
        addafter(Status)
        {
            field("Service & Warranty No."; "Service & Warranty No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("Import Warranty & Services")
            {
                ApplicationArea = All;
                Image = WarrantyLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ImportWarrantyServices();
                end;
            }
        }
    }

    local procedure ImportWarrantyServices()
    var
        WarrantyServiceHdr: Record "LGX ZMO Service & Warranty Hdr";
        ServiceWarrList: page "LGX ZMO Service & Warr. List";
    begin
        if Rec."No." = '' then begin
            Rec.Insert(true);
            Commit();
        end;
        ServiceWarrList.LookupMode(true);
        ServiceWarrList.SetSeleccServWarrant();
        if ServiceWarrList.RunModal() <> Action::LookupOK then
            exit;
        ServiceWarrList.GetRecord(WarrantyServiceHdr);
        WarrantyServiceHdr.TestField("LGX ZMO Sell-To Customer No.");
        WarrantyServiceHdr.InsertWarrantyServices(Rec);
    end;
}