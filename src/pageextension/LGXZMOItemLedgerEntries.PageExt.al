pageextension 50006 "LGX ZMO Item Ledger Entries" extends "Item Ledger Entries" //38
{
    layout
    {
        modify("Cost Amount (Actual)")
        {
            HideValue = not HideCostAndPosting;
        }
        modify("Cost Amount (Actual) (ACY)")
        {
            HideValue = not HideCostAndPosting;
        }
        modify("Cost Amount (Expected)")
        {
            HideValue = not HideCostAndPosting;
        }
        modify("Cost Amount (Expected) (ACY)")
        {
            HideValue = not HideCostAndPosting;
        }
        modify("Cost Amount (Non-Invtbl.)")
        {
            HideValue = not HideCostAndPosting;
        }
        modify("Cost Amount (Non-Invtbl.)(ACY)")
        {
            HideValue = not HideCostAndPosting;
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