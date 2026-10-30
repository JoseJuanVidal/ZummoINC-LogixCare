tableextension 50009 "LGX ZMO Gen. Journal Line" extends "Gen. Journal Line" //81
{
    fields
    {
        field(50000; "LGX ZMO Service & Warranty No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = ' Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
    }
}