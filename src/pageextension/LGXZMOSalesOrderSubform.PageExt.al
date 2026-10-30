pageextension 50014 "LGX ZMO Sales Order Subform" extends "Sales Order Subform" //46
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Line Discount Amount")
        {
            Editable = false;
        }
        addafter("Line Discount Amount")
        {
            field(LGXZMODiscountedPrice; "Unit Price" * ("Line Discount %" / 100))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Discounted Price';
                Editable = false;
            }
            field("LGX ZMO Unit Price After Disc."; "LGX ZMO Unit Price After Disc.")
            {
                ApplicationArea = LGXZMOFunctionality;
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