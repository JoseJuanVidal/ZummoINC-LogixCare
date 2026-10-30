tableextension 50012 "LGX ZMO General Ledger Setup" extends "General Ledger Setup" //98
{
    fields
    {
        field(50000; "LGX ZMO E-Mail Attachment Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail Attachment Path';
        }
    }
}