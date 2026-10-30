pageextension 50027 "LGX ZMO Posted Purchase Inv." extends "Posted Purchase Invoices" //146
{
    layout
    {
        addafter("Order No.")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}