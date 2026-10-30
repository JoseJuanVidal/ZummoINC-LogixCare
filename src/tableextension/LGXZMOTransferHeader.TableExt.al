tableextension 50017 "LGX ZMO TransferHeader" extends "Transfer Header" //5740
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

            trigger OnValidate()
            begin
                Clear("LGX ZMO Requested by Name");
                if SalesPerson.Get("LGX ZMO Requested by") then
                    "LGX ZMO Requested by Name" := SalesPerson.Name;
            end;
        }
        field(50002; "LGX ZMO Requested by Name"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested By Name';
        }
        field(50003; "LGX ZMO Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }
    }

    var
        SalesPerson: Record "Salesperson/Purchaser";
}