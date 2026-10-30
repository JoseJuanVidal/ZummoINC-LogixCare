pageextension 50020 "LGX ZMO Posted Sales Invoice" extends "Posted Sales Invoice" //132
{
    layout
    {
        addbefore("Sell-to Customer Name")
        {
            field("Sell-to Customer No."; "Sell-to Customer No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        addafter(Closed)
        {
            // Antes en Zummo Ext WARRANTY (pageextension 50067)
            field("Service & Warranty No."; "Service & Warranty No.")
            {

            }
            field("LGX ZMO Created By User ID"; "LGX ZMO Created By User ID")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}