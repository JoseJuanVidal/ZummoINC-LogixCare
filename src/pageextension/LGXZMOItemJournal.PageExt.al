pageextension 50007 "LGX ZMO Item Journal" extends "Item Journal" //40
{
    layout
    {
        addafter("Reason Code")
        {
            field("LGX ZMO Comments"; "LGX ZMO Comments")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        addbefore("Unit Cost")
        {
            field("Serial No."; "Serial No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}