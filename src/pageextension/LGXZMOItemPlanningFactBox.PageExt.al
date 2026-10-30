pageextension 50034 "LGX ZMO Item Planning FactBox" extends "Item Planning FactBox" //9091
{
    layout
    {
        addafter("Dampener Quantity")
        {
            field(LGXUsableQtyOnHand; ShowUsableQtyPerLocation("No.", 'HQ'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Hand';
                DecimalPlaces = 0 : 0;
            }
            field(LGXUsableQtyUsed; ShowUsableQtyPerLocation("No.", 'USED'))
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Usable Qty. on Used';
                DecimalPlaces = 0 : 0;
            }
        }
    }
}