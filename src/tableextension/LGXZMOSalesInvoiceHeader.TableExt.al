tableextension 50001 "LGX ZMO Sales Invoice Header" extends "Sales Invoice Header" //112
{
    fields
    {
        field(50000; "LGX ZMO Created By User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By User ID';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50067)
        field(50060; "Service & Warranty No."; code[20])
        {
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
    }
}