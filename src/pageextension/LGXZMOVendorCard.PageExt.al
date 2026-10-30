pageextension 50009 "LGX ZMO Vendor Card" extends "Vendor Card" //26
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("LGX ZMO Service Company"; "LGX ZMO Service Company")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}