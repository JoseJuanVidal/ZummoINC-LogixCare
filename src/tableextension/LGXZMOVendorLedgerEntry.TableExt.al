tableextension 50004 "LGX ZMO Vendor Ledger Entry" extends "Vendor Ledger Entry" //25
{
    fields
    {
        field(50000; "LGX ZMO Serv. & Warranty No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
        field(50001; "LGX ZMO Service & Warranty No."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty No.';
            ObsoleteState = Removed;
            ObsoleteReason = 'Wrong data type';
        }
    }
}