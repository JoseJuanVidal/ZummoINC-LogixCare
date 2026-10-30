tableextension 50021 "LGX ZMO Customer" extends Customer
{
    fields
    {
        field(50000; "LGX ZMO CESCE"; Boolean)
        {
            Caption = 'CESCE';
            DataClassification = CustomerContent;
        }
        field(50001; "LGX ZMO CESCE No."; Code[50])
        {
            Caption = 'CESCE No.';
            DataClassification = CustomerContent;
        }
        field(50002; "LGX ZMO CESCE Cr. Limit"; Decimal)
        {
            Caption = 'CESCE Credit Limit';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
    }
}