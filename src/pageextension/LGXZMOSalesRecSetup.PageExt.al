pageextension 50022 "LGX ZMO Sales & Rec. Setup" extends "Sales & Receivables Setup" //459
{
    layout
    {
        addafter("Direct Debit Mandate Nos.")
        {
            field("LGX ZMO Serv. & Warranty Nos."; "LGX ZMO Serv. & Warranty Nos.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}