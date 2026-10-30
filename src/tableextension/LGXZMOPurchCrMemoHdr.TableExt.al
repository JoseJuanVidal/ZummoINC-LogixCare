tableextension 50015 "LGX ZMO Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr." //124
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