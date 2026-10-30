pageextension 50033 "LGX ZMO Item Invoicing FactBox" extends "Item Invoicing FactBox" //9089
{
    layout
    {
        modify("Standard Cost")
        {
            HideValue = HideCostAndPosting;
            Visible = not HideCostAndPosting;
        }
        modify("Unit Cost")
        {
            HideValue = HideCostAndPosting;
            Visible = not HideCostAndPosting;
        }
        modify("Indirect Cost %")
        {
            HideValue = HideCostAndPosting;
            Visible = not HideCostAndPosting;
        }
        modify("Last Direct Cost")
        {
            HideValue = HideCostAndPosting;
            Visible = not HideCostAndPosting;
        }
        modify("Profit %")
        {
            HideValue = HideCostAndPosting;
            Visible = not HideCostAndPosting;
        }
        addafter("No.")
        {
            field(LGXZMOUsableQtyOnHand; Inventory - "Qty. on Sales Order" - "Qty. on Asm. Component")
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Hand';
                DecimalPlaces = 0 : 0;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component");
    end;

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