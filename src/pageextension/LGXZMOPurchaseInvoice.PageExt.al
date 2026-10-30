pageextension 50017 "LGX ZMO Purchase Invoice" extends "Purchase Invoice" //51
{
    layout
    {
        modify("Posting Description")
        {
            Visible = true;
        }
        addafter("Assigned User ID")
        {
            field("LGX ZMO Service & Warranty No."; "LGX ZMO Service & Warranty No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}