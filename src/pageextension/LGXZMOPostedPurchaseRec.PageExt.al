pageextension 50026 "LGX ZMO Posted Purchase Rec." extends "Posted Purchase Receipts" //145
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("Order Date"; "Order Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}