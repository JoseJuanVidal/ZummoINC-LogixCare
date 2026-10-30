pageextension 50029 "LGX ZMO Transfer Order" extends "Transfer Order" //5740
{
    layout
    {
        addafter(Status)
        {
            field("LGX ZMO Due Date"; "LGX ZMO Due Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
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