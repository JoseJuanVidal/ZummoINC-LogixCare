tableextension 50011 "LGX ZMO User Setup" extends "User Setup" //91
{
    fields
    {
        field(50000; "LGX ZMO Hide Item Field Value"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Hide Item Card Field Value';
        }
        field(50001; "LGX ZMO Prnt Item By Salesper."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Print Item By SalesPerson';
        }
        field(50002; "LGX ZMO Hide Item Card Fld Val"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Hide Item Card Field Value';
            ObsoleteState = Removed;
            ObsoleteReason = 'Wrong data type';
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50068)
        field(50060; "Allow statistics Serv. & Warr."; Boolean)
        { }
    }
}