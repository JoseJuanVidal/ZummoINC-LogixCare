pageextension 50023 "LGX ZMO Payment Journal" extends "Payment Journal" //256
{
    layout
    {
        addafter("Document No.")
        {
            field("Due Date"; "Due Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}