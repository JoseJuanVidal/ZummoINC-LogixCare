tableextension 50008 "LGX ZMO Purchase Header" extends "Purchase Header" //38
{
    fields
    {
        field(50000; "LGX ZMO Service & Warranty No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
    }

}