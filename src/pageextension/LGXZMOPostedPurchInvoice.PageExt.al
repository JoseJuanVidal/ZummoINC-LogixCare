pageextension 50024 "LGX ZMO Posted Purch. Invoice" extends "Posted Purchase Invoice" //138
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("LGX ZMO Service & Warranty No."; "LGX ZMO Service & Warranty No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}