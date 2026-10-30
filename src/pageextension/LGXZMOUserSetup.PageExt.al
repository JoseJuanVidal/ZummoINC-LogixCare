pageextension 50019 "LGX ZMO User Setup" extends "User Setup" //119
{
    layout
    {
        addafter(Email)
        {
            field("LGX ZMO Hide Item Field Value"; "LGX ZMO Hide Item Field Value")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO Prnt Item By Salesper."; "LGX ZMO Prnt Item By Salesper.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}