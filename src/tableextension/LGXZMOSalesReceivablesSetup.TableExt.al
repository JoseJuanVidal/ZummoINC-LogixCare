tableextension 50016 "LGX ZMO Sales&ReceivablesSetup" extends "Sales & Receivables Setup" //311
{
    fields
    {
        field(50000; "LGX ZMO Serv. & Warranty Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty Nos.';
        }
    }
}