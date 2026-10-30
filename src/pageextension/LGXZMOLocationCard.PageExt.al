pageextension 50003 "LGX ZMO Location Card" extends "Location Card" //5703
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("LGX ZMO Due Date Mand."; "LGX ZMO Due Date Mand.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}