pageextension 50011 "LGX ZMO Sales Invoice" extends "Sales Invoice" //43
{
    layout
    {
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