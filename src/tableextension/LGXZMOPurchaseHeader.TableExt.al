tableextension 50008 "LGX ZMO Purchase Header" extends "Purchase Header" //38
{
    fields
    {
        field(50000; "LGX ZMO Service & Warranty No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service & Warranty No.';
            TableRelation = "LGX ZMO Service & Warranty Hdr"."LGX ZMO Incident No.";
        }
        // Antes en Zummo Ext WARRANTY (tableextension 50060)
        field(50060; "Sales Order No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order No.', comment = 'ESP="Sales Order No."';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            begin
                OnValidate_SalesinvoiceNo();
            end;
        }
    }

    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseInvoice: Record "Purch. Inv. Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        lblConfirmDuplicate: Label 'Allocation already exists in Purchases %1 %2 of %3.\Invoices allocation %4\¿Do you wish to continue?',
            comment = 'ESP="Allocation already exists in Purchases %1 %2 of %3.\Invoices allocation %4\¿Do you wish to continue?"';
        lblErrorBlanco: Label 'Sales Order No. has not been indicate', comment = 'ESP="Sales Order No. has not been indicate"';

    local procedure OnValidate_SalesinvoiceNo()
    var
        myInt: Integer;
    begin
        if Rec."Sales Order No." = '' then
            exit;
        // primero comprobamos si existe en el historico de facturas de compras ya asignada
        PurchaseInvoice.Reset();
        PurchaseInvoice.SetRange("Sales Order No.", Rec."Sales Order No.");
        if PurchaseInvoice.FindFirst() then
            if not Confirm(lblConfirmDuplicate, false, PurchaseInvoice.TableName, PurchaseInvoice."No.", PurchaseInvoice."Buy-from Vendor Name", PurchaseInvoice.Count) then
                Rec."Sales Order No." := '';
        // miramos si esta duplicado en facturas de compra pendiente de registro
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.SetFilter("No.", '<>%1', PurchaseHeader."No.");
        PurchaseHeader.SetRange("Sales Order No.", Rec."Sales Order No.");
        if PurchaseHeader.FindFirst() then
            if not Confirm(lblConfirmDuplicate, false, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader."Buy-from Vendor Name", PurchaseHeader.Count) then
                Rec."Sales Order No." := '';
    end;

    procedure ShowSalesInvoices()
    var
        PostedPurchaseInvoices: page "Posted Purchase Invoices";
    begin
        if Rec."Sales Order No." = '' then
            Error(lblErrorBlanco);
        PurchaseInvoice.Reset();
        PurchaseInvoice.SetRange("Sales Order No.", Rec."Sales Order No.");
        PostedPurchaseInvoices.SetTableView(PurchaseInvoice);
        PostedPurchaseInvoices.Run();
    end;
}