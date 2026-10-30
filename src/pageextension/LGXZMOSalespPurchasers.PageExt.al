pageextension 50000 "LGX ZMO Salesp./Purchasers" extends "Salespersons/Purchasers" //14
{
    layout
    {
        addafter("Phone No.")
        {
            field("LGX ZMO SetCustomerListFilter"; "LGX ZMO Set Cust. List Filter")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO SalesPerson User ID"; "LGX ZMO SalesPerson User ID")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}