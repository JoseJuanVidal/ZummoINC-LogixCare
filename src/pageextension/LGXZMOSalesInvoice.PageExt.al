pageextension 50011 "LGX ZMO Sales Invoice" extends "Sales Invoice" //43
{
    layout
    {
        modify(Control1901314507)
        {
            Visible = not HideCostAndPosting;
        }
        // Antes en Zummo Ext WARRANTY (pageextension 50070)
        addafter(Status)
        {
            field("Service & Warranty No."; "Service & Warranty No.")
            { }
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