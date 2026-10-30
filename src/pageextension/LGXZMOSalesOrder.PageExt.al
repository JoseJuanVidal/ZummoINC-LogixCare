pageextension 50008 "LGX ZMO Sales Order" extends "Sales Order" //42
{
    layout
    {
        addafter(Status)
        {
            // Antes en Zummo Ext WARRANTY (pageextension 50066)
            field("Service & Warranty No."; "Service & Warranty No.")
            {

            }
            field("LGX ZMO Created By User ID"; "LGX ZMO Created By User ID")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        modify(Control1901314507)
        {
            Visible = not HideCostAndPosting;
        }
    }

    actions
    {
        modify(Statistics)
        {
            Visible = not HideCostAndPosting;
        }
        // Antes en Zummo Ext WARRANTY (pageextension 50066)
        addfirst("P&osting")
        {
            action("Calculate Tariff")
            {
                ApplicationArea = All;
                Image = TaxPayment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    Functions: Codeunit "ZM Event Suscriber";
                begin
                    Functions.CalculateTariffSalesHeader(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then
            HideCostAndPosting := UserSetup."LGX ZMO Hide Item Field Value";
    end;

    var
        HideCostAndPosting: Boolean;

    local procedure ImportWarrantyServices()
    var
        WarrantyServiceHdr: Record "LGX ZMO Service & Warranty Hdr";
        ServiceWarrList: page "LGX ZMO Service & Warr. List";
    begin
        ServiceWarrList.LookupMode(true);
        ServiceWarrList.SetSeleccServWarrant();
        if ServiceWarrList.RunModal() <> Action::LookupOK then
            exit;
        ServiceWarrList.GetRecord(WarrantyServiceHdr);


        WarrantyServiceHdr.InsertWarrantyServices(Rec);
    end;
}
