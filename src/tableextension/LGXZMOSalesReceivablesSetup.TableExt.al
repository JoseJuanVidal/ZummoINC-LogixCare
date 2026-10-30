tableextension 50016 "LGX ZMO Sales&ReceivablesSetup" extends "Sales & Receivables Setup" //311
{
    fields
    {
        field(50000; "LGX ZMO Serv. & Warranty Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty Nos.';
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50063)
        field(50060; "Maximum Discount"; Decimal)
        {
        }
        field(50061; "G/L Account No. Tariff"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50062; "Tariff %"; Decimal)
        {
        }
        field(50063; "Tariff Description"; text[100])
        {
        }
        field(50065; "Warr & Serv. Taxes"; Decimal)
        {
        }
        field(50066; "G/L Account Shipment"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50067; "G/L Account Labor/Travel"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50068; "G/L Account Rush Fee"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50069; "Operations Email"; text[100])
        {
        }
        field(50070; "Labors Hours Fees"; Decimal)
        {
        }
        field(50071; "Travel Hours Fees"; Decimal)
        {
        }
    }
}