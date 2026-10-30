tableextension 50005 "LGX ZMO Item Ledger Entry" extends "Item Ledger Entry" //32
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