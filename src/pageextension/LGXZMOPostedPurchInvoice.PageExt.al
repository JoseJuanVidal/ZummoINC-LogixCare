pageextension 50024 "LGX ZMO Posted Purch. Invoice" extends "Posted Purchase Invoice" //138
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("LGX ZMO Service & Warranty No."; "LGX ZMO Service & Warranty No.")
            {
                ApplicationArea = LGXZMOFunctionality;

                // Antes en Zummo Ext WARRANTY (pageextension 50061)
                trigger OnValidate()
                begin
                    OnValidate_ServiceWarranty();
                end;
            }
            // Antes en Zummo Ext WARRANTY (pageextension 50061)
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseInvoice: Record "Purch. Inv. Header";
        lblConfirmDuplicate: Label 'Service & Warranty No. already exists in Purchases %1 %2 of %3.\Invoices allocation %4\¿Do you wish to continue?',
            comment = 'ESP="Service & Warranty No. already exists in Purchases %1 %2 of %3.\Invoices allocation %4\¿Do you wish to continue?"';
        lblErrorBlanco: Label 'Service & Warranty No. has not been indicate', comment = 'ESP="Service & Warranty No. has not been indicate"';

    local procedure OnValidate_ServiceWarranty()
    var
        myInt: Integer;
    begin
        if Rec."LGX ZMO Service & Warranty No." = '' then
            exit;
        // primero comprobamos si existe en el historico de facturas de compras ya asignada
        PurchaseInvoice.Reset();
        PurchaseInvoice.SetRange("LGX ZMO Service & Warranty No.", Rec."LGX ZMO Service & Warranty No.");
        if PurchaseInvoice.FindFirst() then
            if not Confirm(lblConfirmDuplicate, false, PurchaseInvoice.TableName, PurchaseInvoice."No.", PurchaseInvoice."Buy-from Vendor Name", PurchaseInvoice.Count) then
                Rec."LGX ZMO Service & Warranty No." := '';
        // miramos si esta duplicado en facturas de compra pendiente de registro
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.SetFilter("No.", '<>%1', PurchaseHeader."No.");
        PurchaseHeader.SetRange("LGX ZMO Service & Warranty No.", Rec."LGX ZMO Service & Warranty No.");
        if PurchaseHeader.FindFirst() then
            if not Confirm(lblConfirmDuplicate, false, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader."Buy-from Vendor Name", PurchaseHeader.Count) then
                Rec."LGX ZMO Service & Warranty No." := '';
    end;
}
