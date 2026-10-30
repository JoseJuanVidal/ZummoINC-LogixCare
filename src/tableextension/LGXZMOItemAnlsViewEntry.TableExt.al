tableextension 50022 "LGX ZMO Item Anls View Entry" extends "Item Analysis View Entry" //7154
{
    fields
    {
        field(50000; "LGX ZMO Item Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Item Ledger Entry No.';
            Editable = false;
        }
        field(50001; "LGX ZMO Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
            Editable = false;
        }
    }
}