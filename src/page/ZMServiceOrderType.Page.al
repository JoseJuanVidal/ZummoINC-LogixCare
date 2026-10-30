page 50015 "ZM Service Order Type"
{
    PageType = List;
    Caption = 'Aux List';
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM Service Order Type";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Code2; Code2)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fault Spain"; "Fault Spain")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fault Location Spain"; "Fault Location Spain")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}