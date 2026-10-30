pageextension 50010 "LGX ZMO Vendor Ledger Entries" extends "Vendor Ledger Entries" //29
{
    layout
    {
        addafter("Document No.")
        {
            field("Document Date"; "Document Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        addafter(Description)
        {
            field("LGX ZMO Serv. & Warranty No."; "LGX ZMO Serv. & Warranty No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}