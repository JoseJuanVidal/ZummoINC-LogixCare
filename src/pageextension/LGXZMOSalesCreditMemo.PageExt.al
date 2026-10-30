pageextension 50012 "LGX ZMO Sales Credit Memo" extends "Sales Credit Memo" //44
{
    actions
    {
        modify(Statistics)
        {
            Visible = not HideCostAndPosting;
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