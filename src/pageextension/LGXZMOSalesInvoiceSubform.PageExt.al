pageextension 50015 "LGX ZMO Sales Invoice Subform" extends "Sales Invoice Subform" //47
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            HideValue = HideCostAndPosting;
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