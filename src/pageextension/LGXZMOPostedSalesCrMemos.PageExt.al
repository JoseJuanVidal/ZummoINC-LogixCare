pageextension 50042 "LGX ZMO Posted Sales Cr. Memos" extends "Posted Sales Credit Memos" //144
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