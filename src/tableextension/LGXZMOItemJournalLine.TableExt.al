tableextension 50010 "LGX ZMO Item Journal Line" extends "Item Journal Line" //83
{
    fields
    {
        field(50000; "LGX ZMO Comments"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }
    }
}