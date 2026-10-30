pageextension 50030 "LGX ZMO Posted Tran. Shipments" extends "Posted Transfer Shipments" //5743
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