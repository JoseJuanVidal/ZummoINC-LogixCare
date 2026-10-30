table 50006 "ZM Serv & Warr Items"
{
    DataClassification = CustomerContent;
    Caption = 'Serv. & Warranty Items';
    LookupPageId = "ZM Service & Warranty Items";
    DrillDownPageId = "ZM Service & Warranty Items";

    fields
    {
        field(1; "LGX ZMO Incident No."; Code[20])
        {
            Caption = 'Incident No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr";

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(5; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No';
            TableRelation = Item;

            trigger OnValidate()
            begin
                OnValidate_ItemNo();
            end;
        }
        field(6; Description; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(11; Inventory; Decimal)
        {
            Caption = 'Inventory';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No.")));
            Editable = false;
        }
        field(15; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(16; Amount; decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(17; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     UpdateAmounts();
            // end;
        }
        field(50000; "Service Type"; code[20])
        {
            // tipo pedido servicio
            DataClassification = CustomerContent;
            Caption = 'Service Type';
            TableRelation = "ZM Service Order Type".Code where(Type = const("Service Order Type"));
        }
        field(50001; "Fault"; code[20])
        {
            // Fallo
            DataClassification = CustomerContent;
            Caption = 'Fault';
            TableRelation = "ZM Service Order Type".Code where(Type = const(Fault));
        }
        field(50002; "Localized Fault"; code[20])
        {
            // Fallo localizado
            DataClassification = CustomerContent;
            Caption = 'Localized Fault';
            TableRelation = if (Fault = const('')) "ZM Service Order Type".Code where(Type = const("Localized Fault")) else
            "ZM Service Order Type".Code where(Type = const("Localized Fault"), Code2 = field(Fault));

            trigger OnValidate()
            begin
                Validate_FaultLocationSpain();
            end;
        }
        field(50003; Warranty; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Warranty';
        }
    }
    keys
    {
        key(PK; "LGX ZMO Incident No.", "Line No.")
        {
            Clustered = true;
        }
    }


    var
        ServWarrItems: Record "ZM Serv & Warr Items";

    trigger OnInsert()
    begin
        // if Rec."Line No." = 0 then
        //     UpdateLastLineNo();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        Item: Record Item;

    local procedure UpdateLastLineNo()
    var
        myInt: Integer;
    begin
        ServWarrItems.Reset();
        if Rec.GetFilter("LGX ZMO Incident No.") = '' then
            exit;
        ServWarrItems.SetFilter("LGX ZMO Incident No.", Rec.GetFilter("LGX ZMO Incident No."));
        if ServWarrItems.FindLast() then
            Rec."Line No." := ServWarrItems."Line No." + 10000
        else
            Rec."Line No." := 100000;
    end;

    procedure OnValidate_ItemNo()
    var
        LGXWarrantyHeader: record "LGX ZMO Service & Warranty Hdr";
        lblConfirm: Label '¿Do you want to change the Item No. %1 - %2?';
        lblError: Label 'Canceled by user';
    begin
        LGXWarrantyHeader.Get(Rec."LGX ZMO Incident No.");
        Item.Get(Rec."Item No.");
        if Rec."Item No." = xRec."Item No." then
            exit;
        if xRec."Item No." <> '' then
            if not Confirm(lblConfirm, false, Item."No.", Item.Description) then
                error(lblError);
        Rec.Description := Item.Description;

        UpdateUnitPrice();
        Rec."Unit Cost" := Item."Unit Cost";
        Rec.CalcFields(Inventory);

    end;

    procedure UpdateUnitPrice()
    var
        Customer: Record Customer;
        WarrantyServices: Record "LGX ZMO Service & Warranty Hdr";
        ToSalesPrice: Record "Sales Price" temporary;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        Item.Get(Rec."Item No.");
        if not WarrantyServices.Get(Rec."LGX ZMO Incident No.") then
            exit;
        if WarrantyServices."LGX ZMO Warranty" then begin
            Rec."Unit Price" := 0;
            exit;
        end;
        if Customer.Get(WarrantyServices."LGX ZMO Sell-To Customer No.") then begin
            SalesPriceCalcMgt.FindSalesPrice(ToSalesPrice, WarrantyServices."LGX ZMO Sell-To Customer No.", '', Customer."Customer Price Group",
                '', Rec."Item No.", '', Item."Sales Unit of Measure", '', WorkDate(), false);
            SalesPriceCalcMgt.CalcBestUnitPrice(ToSalesPrice);
            Rec."Unit Price" := ToSalesPrice."Unit Price";
        end;
        if (Rec."Unit Price" = 0) and (Item."Unit Price" <> 0) then
            Rec."Unit Price" := Item."Unit Price";
    end;

    local procedure Validate_FaultLocationSpain()
    var
        Fault: Record "ZM Service Order Type";
    begin
        Fault.Reset();
        Fault.SetRange(Type, Fault.Type::"Localized Fault");
        Fault.SetRange(Code, Rec."Localized Fault");
        if Fault.FindFirst() then begin
            if Fault.Code2 <> Rec.Fault then begin
                Rec.Fault := Fault.Code2;
            end
        end;
    end;

    local procedure UpdateAmounts()
    var
        myInt: Integer;
    begin
        Rec.Amount := Rec.Quantity * Rec."Unit Price";
    end;

    procedure UpdateUnitCost()
    var
        myInt: Integer;
    begin
        if Item.Get(Rec."Item No.") then
            Rec."Unit Cost" := Item."Unit Cost";
    end;
}