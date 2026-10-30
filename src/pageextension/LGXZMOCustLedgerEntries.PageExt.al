pageextension 50043 "LGX ZMO Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("LGX ZMO CESCE"; "LGX ZMO CESCE")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE No."; "LGX ZMO CESCE No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE Cr. Limit"; "LGX ZMO CESCE Cr. Limit")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}