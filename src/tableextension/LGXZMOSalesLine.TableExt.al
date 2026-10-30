tableextension 50007 "LGX ZMO Sales Line" extends "Sales Line" //37
{
    fields
    {
        field(50000; "LGX ZMO Unit Price After Disc."; Decimal)
        {
            Caption = 'Unit Price After Discount';
            DataClassification = CustomerContent;
        }
    }
}