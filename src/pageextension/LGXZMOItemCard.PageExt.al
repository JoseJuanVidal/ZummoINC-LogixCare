pageextension 50004 "LGX ZMO Item Card" extends "Item Card" //30
{
    layout
    {
        modify("Costs & Posting")
        {
            Visible = not HideCostAndPosting;
        }
        modify("Standard Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Unit Cost")
        {
            HideValue = HideCostAndPosting;
        }
        addafter(InventoryNonFoundation)
        {
            field(LGXUsableQtyOnHand; ShowUsableQtyPerLocation("No.", 'HQ'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Hand';
                DecimalPlaces = 0 : 0;
            }
            field(LGXUsableQtyUsed; ShowUsableQtyPerLocation("No.", 'USED'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Used';
                DecimalPlaces = 0 : 0;
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
}