pageextension 50016 "LGX ZMO Purchase Order" extends "Purchase Order" //50
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