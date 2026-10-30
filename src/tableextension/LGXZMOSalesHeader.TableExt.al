tableextension 50006 "LGX ZMO Sales Header" extends "Sales Header" //36
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate();
            begin
                CheckOpenOrdersForCustomer();
            end;
        }
        field(50000; "LGX ZMO Created By User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By User ID';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50066)
        field(50060; "Service & Warranty No."; code[20])
        {
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
    }

    trigger OnBeforeInsert()
    begin
        if "Document Type" = "Document Type"::Order then
            "LGX ZMO Created By User ID" := CopyStr(UserId(), 1, 50);
    end;

    local procedure CheckOpenOrdersForCustomer()
    var
        Cust: Record Customer;
    begin
        IF Cust.GET("Sell-to Customer No.") then begin
            Cust.CalcFields("No. of Orders");
            IF Cust."No. of Orders" > 0 then
                MESSAGE('Customer %1 has Items yet to be shipped, Open or Released Sales Order', "Sell-to Customer No.");
        end;
    end;
}