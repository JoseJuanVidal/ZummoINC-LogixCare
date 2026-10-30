tableextension 50014 "LGX ZMO Purch. Inv. Header" extends "Purch. Inv. Header" //122
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