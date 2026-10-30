pageextension 50041 "LGX ZMO Posted Sales Invoices" extends "Posted Sales Invoices" //143
{
    layout
    {
        addbefore("Sell-to Post Code")
        {
            field("Sell-to City"; "Sell-to City")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("Sell-to County"; "Sell-to County")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}