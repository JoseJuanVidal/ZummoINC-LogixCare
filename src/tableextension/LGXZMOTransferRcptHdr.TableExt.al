tableextension 50020 "LGX ZMO TransferRcptHdr" extends "Transfer Receipt Header" //5745
{
    fields
    {
        field(50000; "LGX ZMO Requisition Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Date';
        }
        field(50001; "LGX ZMO Requested by"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested By';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50002; "LGX ZMO Requested by Name"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested By Name';
        }
    }
}