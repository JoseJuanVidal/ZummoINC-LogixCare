pageextension 50032 "LGX ZMO Item Ana. View Entries" extends "Item Analysis View Entries" //7153
{
    layout
    {
        addafter("Cost Amount (Expected)")
        {
            field("Source Type"; "Source Type")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("Source No."; "Source No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        addafter("Invoiced Quantity")
        {
            field(LGXZMOSourceName; SourceName)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Source Name';
            }
            field(LGXZMOOrderNo; OrderNo)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Order No.';
            }
            field(LGXZMODocumentNo; DocumentNo)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Document No.';
            }
            field(LGXZMOExtDocumentNo; ExternalDocumentNo)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'External Document No.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(SourceName);
        case "Source Type" of
            "Source Type"::Item:
                if Item.Get("Source No.") then
                    SourceName := Item.Description;

            "Source Type"::Vendor:
                if Vendor.Get("Source No.") then
                    SourceName := Vendor.Name;

            "Source Type"::Customer:
                if Customer.Get("Source No.") then
                    SourceName := Customer.Name;
        end;

        Clear(DocumentNo);
        Clear(ExternalDocumentNo);
        Clear(OrderNo);
        ValueEntry.Reset();
        ValueEntry.SetRange("Posting Date", "Posting Date");
        ValueEntry.SetRange("Location Code", "Location Code");
        ValueEntry.SetRange("Source Type", "Source Type");
        ValueEntry.SetRange("Source No.", "Source No.");
        if ValueEntry.FindFirst() then begin
            DocumentNo := ValueEntry."Document No.";
            OrderNo := ValueEntry."Order No.";
            ExternalDocumentNo := ValueEntry."External Document No.";
        end;
    end;

    var
        Item: Record Item;
        Vendor: Record Vendor;
        Customer: Record Customer;
        ValueEntry: Record "Value Entry";
        SourceName: Text[100];
        DocumentNo: Code[20];
        OrderNo: Code[20];
        ExternalDocumentNo: Code[35];
}