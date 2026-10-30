tableextension 50000 "LGX ZMO Salesperson/Purchaser" extends "Salesperson/Purchaser" //13
{
    fields
    {
        field(50000; "LGX ZMO Set Cust. List Filter"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Set Customer List Filter';
        }
        field(50001; "LGX ZMO Salesperson User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }
}