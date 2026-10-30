page 50006 "LGX ZMO Serv. & Warr. Act."
{
    Caption = 'Service & Warranty Activities';
    PageType = CardPart;
    SourceTable = "LGX ZMO Service & Warranty Cue";

    layout
    {
        area(content)
        {
            cuegroup("Service Status")
            {
                Caption = 'Service Status';
                field("Service Status - Opened"; "LGX ZMO Serv. Status - Opened")
                {
                    DrillDownPageID = "LGX ZMO Service & Warr. List";
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Status - Closed"; "LGX ZMO Serv. Status - Closed")
                {
                    DrillDownPageID = "LGX ZMO Service & Warr. List";
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
            cuegroup("Warranty Status")
            {
                Caption = 'Warranty Status';
                field("Warranty Status - Repaired"; "LGX ZMO Warr. Stat. - Repaired")
                {
                    DrillDownPageID = "LGX ZMO Service & Warr. List";
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Warranty Status - Replaced"; "LGX ZMO Warr. Stat. - Replaced")
                {
                    DrillDownPageID = "LGX ZMO Service & Warr. List";
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        Reset();
        if NOT Get() then begin
            Init();
            Insert();
        end;
    end;
}

