pageextension 50031 "LGX ZMO Posted Tran. Receipt" extends "Posted Transfer Receipt" //5745
{
    layout
    {
        addafter("Posting Date")
        {
            field("LGX ZMO Requisition Date"; "LGX ZMO Requisition Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO Requested by"; "LGX ZMO Requested by")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO Requested by Name"; "LGX ZMO Requested by Name")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}