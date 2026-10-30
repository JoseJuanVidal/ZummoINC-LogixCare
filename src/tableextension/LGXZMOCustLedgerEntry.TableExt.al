tableextension 50026 "LGX ZMO Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "LGX ZMO CESCE"; Boolean)
        {
            Caption = 'CESCE';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50001; "LGX ZMO CESCE No."; Code[50])
        {
            Caption = 'CESCE No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "LGX ZMO CESCE Cr. Limit"; Decimal)
        {
            Caption = 'CESCE Credit Limit';
            DataClassification = CustomerContent;
            BlankZero = true;
            Editable = false;
        }
    }
}