page 50004 "LGX ZMO Service Warr. Comments"
{
    Caption = 'Service & Warranty Comments';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "LGX ZMO Service Warr. Comment";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "LGX ZMO No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Line No."; "LGX ZMO Line No.")
                {
                    Editable = false;
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Date; "LGX ZMO Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Comment; "LGX ZMO Comment")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
        }
    }
}

