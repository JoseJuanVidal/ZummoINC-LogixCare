tableextension 50013 "LGX ZMO Purch. Rcpt. Header" extends "Purch. Rcpt. Header" //120
{
    fields
    {
        field(50000; "LGX ZMO Service & Warranty No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr";
        }
    }
}