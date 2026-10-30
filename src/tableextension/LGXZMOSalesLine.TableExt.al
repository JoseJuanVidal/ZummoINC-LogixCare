tableextension 50007 "LGX ZMO Sales Line" extends "Sales Line" //37
{
    fields
    {
        field(50000; "LGX ZMO Unit Price After Disc."; Decimal)
        {
            Caption = 'Unit Price After Discount';
            DataClassification = CustomerContent;
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50065)
        field(50060; "line Amount inc Tariff"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'line Amount inc Tariff';
        }
        field(50062; "line Tariff"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'line Tariff';
        }
    }
}