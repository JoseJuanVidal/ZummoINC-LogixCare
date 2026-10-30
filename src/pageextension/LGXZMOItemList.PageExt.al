pageextension 50005 "LGX ZMO Item List" extends "Item List" //31
{
    layout
    {
        modify("Standard Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Unit Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Last Direct Cost")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Price/Profit Calculation")
        {
            HideValue = HideCostAndPosting;
        }
        modify("Profit %")
        {
            HideValue = HideCostAndPosting;
        }
        addbefore("Substitutes Exist")
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
            field(LGXPurchaseQuantity; "Qty. on Purch. Order")
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Purchase Order Qty.';
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