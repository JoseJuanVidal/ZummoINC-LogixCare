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
        // Antes en Zummo Ext WARRANTY (pageextension 50072)
        addlast(Control1)
        {
            field("Allow statistics Serv. & Warr."; "Allow statistics Serv. & Warr.")
            {
                ApplicationArea = All;
            }
        }
    }
}
