pageextension 50018 "LGX ZMO General Ledger Setup" extends "General Ledger Setup" //118
{
    layout
    {
        addafter("PAC Environment")
        {
            field("LGX ZMO E-Mail Attachment Path"; "LGX ZMO E-Mail Attachment Path")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}