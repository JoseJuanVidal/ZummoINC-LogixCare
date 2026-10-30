codeunit 50005 "ZM Event Suscriber"
{
    Permissions = tabledata "Sales Invoice Header" = rmid;
    trigger OnRun()
    begin

    end;

    procedure AssingWarrantyServices(SalesInvoiceHeaderNo: code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ServiceWarrantyHdr: Record "LGX ZMO Service & Warranty Hdr";
    begin
        SalesInvoiceHeader.Get(SalesInvoiceHeaderNo);
        if page.RunModal(0, ServiceWarrantyHdr) = Action::LookupOK then begin
            SalesInvoiceHeader."Service & Warranty No." := ServiceWarrantyHdr."LGX ZMO Incident No.";
            SalesInvoiceHeader.Modify();
        end;
    end;

    var
        myInt: Integer;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, true)]
    // local procedure SalesLine_OnAfterInsertEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    // begin
    //     // SalesLine_InsertLineOfTariff(Rec);
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', true, true)]
    // local procedure SalesLine_OnAfterModifyEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    // begin
    //     // SalesLine_InsertLineOfTariff(Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, Page::"Sales Invoice Subform", 'OnInsertRecordEvent', '', true, true)]
    // local procedure SalesOrderSubform_OnInsertRecordEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; var AllowInsert: Boolean; BelowxRec: Boolean)
    // begin
    //     SalesLine_InsertLineOfTariff(Rec, true);
    // end;

    // [EventSubscriber(ObjectType::Page, Page::"Sales Invoice Subform", 'OnModifyRecordEvent', '', true, true)]
    // local procedure SalesOrderSubform_OnModifyRecordEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; var AllowModify: Boolean)
    // begin
    //     SalesLine_InsertLineOfTariff(Rec, true);
    // end;
    // controlamos que si es un pedido o una factura, y si 
    local procedure SalesLine_InsertLineOfTariff(Rec: Record "Sales Header")
    var
        Currency: Record Currency;
        SalesSetup: record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        NewSalesLine: Record "Sales Line";
        VatBaseAmount: Decimal;
        RoundingPrecision: Decimal;
    begin
        if not SalesSetup.Get() then
            exit;
        if SalesSetup."Tariff %" = 0 then
            exit;
        SalesSetup.TestField("G/L Account No. Tariff");

        VatBaseAmount := GetSalesOrderLineAmountItem(Rec);
        if VatBaseAmount = 0 then begin
            DeleteTariffLine(Rec, SalesSetup."G/L Account No. Tariff");
            exit;
        end;
        if Currency.Get(Rec."Currency Code") then
            RoundingPrecision := Currency."Amount Rounding Precision"
        else
            RoundingPrecision := 0.01;

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst() then
            repeat
                SalesLine."line Amount inc Tariff" := round(SalesLine."Line Amount" + (SalesLine."Line Amount" * SalesSetup."Tariff %" / 100), Currency."Amount Rounding Precision");
                SalesLine.Modify();
            until SalesLine.Next() = 0;

        NewSalesLine.SuspendStatusCheck(true);
        NewSalesLine.SetRange("Document Type", Rec."Document Type");
        NewSalesLine.SetRange("Document No.", Rec."No.");
        NewSalesLine.SetRange("Line No.", 9999999);
        if not NewSalesLine.FindFirst() then begin
            NewSalesLine.Init();
            NewSalesLine."Document Type" := Rec."Document Type";
            NewSalesLine."Document No." := Rec."No.";
            NewSalesLine."Line No." := 9999999; // Rec."Line No." + 10;
            NewSalesLine.Type := SalesLine.Type::"G/L Account";
            NewSalesLine.Insert(true);
        end;
        NewSalesLine.Validate("No.", SalesSetup."G/L Account No. Tariff");
        if SalesSetup."Tariff Description" <> '' then
            NewSalesLine.Validate(Description, copystr(StrSubstNo(SalesSetup."Tariff Description", Rec."No.", SalesSetup."Tariff %"), 1, MaxStrLen(SalesLine.Description)));
        NewSalesLine.Validate(Quantity, 1);
        NewSalesLine.Validate("Unit Price", round(VatBaseAmount * SalesSetup."Tariff %" / 100, Currency."Amount Rounding Precision"));
        // Round((Rec."Line Amount" / Rec.Quantity) * SalesSetup."Tariff %" / 100, Currency."Amount Rounding Precision"));
        NewSalesLine.Validate("line Tariff", true);
        NewSalesLine.Validate("Tax Group Code", SalesLine."Tax Group Code");
        NewSalesLine.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        NewSalesLine.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        NewSalesLine.Modify();
        NewSalesLine.SuspendStatusCheck(false);

    end;

    local procedure DeleteTariffLine(Rec: Record "Sales Header"; GLAccountNo: code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        SalesLine.SetRange("No.", GLAccountNo);
        if SalesLine.FindFirst() then
            SalesLine.Delete(true);
    end;

    local procedure GetSalesOrderLineAmountItem(Rec: Record "Sales Header"): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.CalcSums("VAT Base Amount");
        exit(SalesLine."VAT Base Amount");
    end;

    // [EventSubscriber(ObjectType::codeunit, codeunit::"Release Sales Document", 'OnBeforeManualReleaseSalesDoc', '', true, true)]
    // local procedure ReleaseSalesDocument_OnBeforeManualReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    // begin
    //     CalculateTariffSalesHeader(SalesHeader)
    // end;

    procedure CalculateTariffSalesHeader(SalesHeader: Record "Sales Header")
    var
        SalesSetup: record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        lblConfirm: label 'You want to calculate and add Tariff lines of %1 %2?';
    begin
        if not SalesSetup.Get() then
            exit;
        if SalesSetup."Tariff %" = 0 then begin
            DeleteTariffLine(SalesHeader, SalesSetup."G/L Account No. Tariff");
            exit;
        end;
        if not Confirm(lblConfirm, false, SalesHeader."Document Type", SalesHeader."No.") then
            exit;
        SalesLine_InsertLineOfTariff(SalesHeader);
    end;

    // =============    EXPORTAR LINEA DE SERVICIO ITEM          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================


    procedure ExportSerViceItemLine(var SalesInvHeader: Record "Sales Invoice Header")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Item: record Item;
        SalesHeader: record "Sales Header";
        SalesLine: record "Sales Line";
        SalesCRMemoHeader: record "Sales Cr.Memo Header";
        SalesCRMemoLine: record "Sales Cr.Memo Line";
        ServiceItem: Record "Service Item";
        ServiceItemLine: Record "Service Item Line";
        ServiceLine: record "Service Line";
        Ventana: Dialog;
    begin
        Ventana.Open('Pedido Servicio #1##################\Nº Pedido #2#######################\Nº Linea #3#######################');
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Service Item');



        if SalesInvHeader.FindFirst() then begin
            AddHeadersExcel(ExcelBuffer, SalesInvHeader.GetFilters());
            repeat
                UpdateExcelSalesInvLine(ExcelBuffer, SalesInvHeader);
            Until SalesInvHeader.next() = 0;
            Ventana.Close();

            ExcelBuffer.WriteSheet('Posted Sales Invoices Warranties', COMPANYNAME, USERID);
            ExcelBuffer.CloseBook();
            ExcelBuffer.SetFriendlyFilename('Sales Invoice');
            ExcelBuffer.OpenExcel();
        end;

    end;

    local procedure AddHeadersExcel(var ExcelBuffer: Record "Excel Buffer" temporary; FilterText: Text)
    begin
        ExcelBuffer.AddColumn('Listado Sales Invoice', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('Filters: %1', FilterText), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('Posting Date'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('No.'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Client'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('External Doc. No.'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Warranties & Service'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Response'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Quantity'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Unit price'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Line discount'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Sales Line Amount'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Quantity'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Unit Cost'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(StrSubstNo('Amount'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
    end;

    local procedure UpdateExcelSalesInvLine(var ExcelBuffer: Record "Excel Buffer" temporary; SalesInvHeader: Record "Sales Invoice Header")
    var
        Item: record Item;
        SalesInvLine: Record "Sales Invoice Line";
        WarrantiesServices: Record "LGX ZMO Service & Warranty Hdr";
    begin
        if WarrantiesServices.Get(SalesInvHeader."Service & Warranty No.") then;
        // primero ponemos los datos de la factura
        ExcelBuffer.AddColumn(SalesInvHeader."Posting Date", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader."No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader."Sell-to Customer Name", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader."External Document No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader."Service & Warranty No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(WarrantiesServices.Response, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FindSet() then
            repeat
                if Item.Get(SalesInvLine."No.") then;
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SalesInvLine."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(SalesInvLine.Quantity * Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.NewRow;
            until SalesInvLine.Next() = 0;
    end;
    // EnterCell(RowNo, ColNo, STRSUBSTNO('=SUM(e%1:e%2) * 100', RowNo - (tmpBOM.COUNT), RowNo - 1),
    //   TRUE, TRUE, '##0.00', '', FALSE, 0);

    procedure ExportExcelServiceWarranty(var ServWarrantHdr: Record "LGX ZMO Service & Warranty Hdr")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Filters: text;
        RangeMin: date;
        RangeMax: date;
        Window: Dialog;
        lblConfirm: Label 'No filter has been indicated\¿Do you want to continue?';
        lblDialog: Label 'Service & Warranty #1#############';
    begin
        Filters := ServWarrantHdr.GetFilters();
        if Filters = '' then
            if not Confirm(lblConfirm) then
                exit;

        Window.Open(lblDialog);
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Service & Warranty');
        // creamos la cabecera de la excel
        HeaderServiceWarrantyExcelBuffer(ExcelBuffer, Filters, ServWarrantHdr);

        // añadimos las líneas
        if ServWarrantHdr.FindFirst() then
            repeat
                Window.Update(1, ServWarrantHdr."LGX ZMO Incident No.");

                LineServiceWarrantyExcelBuffer(ExcelBuffer, ServWarrantHdr);

            Until ServWarrantHdr.next() = 0;
        Window.Close();
        ExcelBuffer.WriteSheet('Proveedor - tarifa precios', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.DownloadAndOpenExcel;

    end;

    local procedure HeaderServiceWarrantyExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; TextoFiltro: text; ServWarrantHdr: Record "LGX ZMO Service & Warranty Hdr")
    var
        Vendor: Record Vendor;
        Item: Record Item;
        PurchasePrice: Record "Purchase Price";
    begin
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Incident No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Incident Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Closed Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Sell-to Customer Name"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Warranty"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Action Taken"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("Actiont Type"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Item No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("LGX ZMO Item Description"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption(Response), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("Service Type"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("Service Order"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("Cost Total"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.FieldCaption("Items No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order Line Items No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Sales Order Line Items Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Sales Order Line Costs', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Purchase Lines No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Purchase Lines Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow();
    end;

    local procedure LineServiceWarrantyExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; ServWarrantHdr: Record "LGX ZMO Service & Warranty Hdr")
    var
        Vendor: Record Vendor;
        Item: Record Item;
        PurchasePrice: Record "Purchase Price";
    begin
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Incident No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Incident Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Closed Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Warranty", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Action Taken", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."Actiont Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."LGX ZMO Item Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr.Response, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."Service Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."Service Order", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."Cost Total", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ServWarrantHdr."Items No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order Line Items No.', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order Line Items Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sales Order Line Costs', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Lines No.', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Lines Amount', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    procedure ExportAnalisisCostesProductos()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Item: record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Ventana: Dialog;
    begin
        Ventana.Open('Item: #1##################\Año: #2#######################\Entry No: #3#######################');
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Items');
        AddCostesProductosHeadersExcel(ExcelBuffer, Item);
        if Item.FindFirst() then
            repeat
                Ventana.Update(1, Item."No.");
                ItemLedgerEntry.SetRange("Item No.", Item."No.");
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                ItemLedgerEntry.SetRange("Posting Date", 20230101D, Today());
                if ItemLedgerEntry.FindFirst() then
                    AddExcelLinesCostesProductos(ExcelBuffer, Item);
            until Item.Next() = 0;
        Ventana.Close();

        ExcelBuffer.WriteSheet('Items purchases Cost', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Items Directs Costs');
        ExcelBuffer.OpenExcel();
    end;

    local procedure AddCostesProductosHeadersExcel(var ExcelBuffer: Record "Excel Buffer" temporary; Item: Record Item)
    begin
        ExcelBuffer.AddColumn('Items Sales Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Año 2023', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Año 2024', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Año 2025', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Año 2026', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(Item.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2023 Cantidad', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2023 Coste Factura compra', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2023 Coste Flete Factura', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2023 Otros Coste Portes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2023 Costes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2024 Cantidad', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2024 Coste Factura compra', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2024 Coste Flete Factura', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2024 Otros Coste Portes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2024 Costes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2025 Cantidad', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2025 Coste Factura compra', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2025 Coste Flete Factura', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2025 Otros Coste Portes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2025 Costes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2026 Cantidad', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2026 Coste Factura compra', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2026 Coste Flete Factura', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2026 Otros Coste Portes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('2026 Costes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
    end;

    local procedure AddExcelLinesCostesProductos(var ExcelBuffer: Record "Excel Buffer" temporary; Item: Record Item)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Posting Date", 20230101D, 20231231D);
        AddExcelLinesCostesProductosDetail(ExcelBuffer, Item, ItemLedgerEntry);
        ItemLedgerEntry.SetRange("Posting Date", 20240101D, 20241231D);
        AddExcelLinesCostesProductosDetail(ExcelBuffer, Item, ItemLedgerEntry);
        ItemLedgerEntry.SetRange("Posting Date", 20250101D, 20251231D);
        AddExcelLinesCostesProductosDetail(ExcelBuffer, Item, ItemLedgerEntry);
        ItemLedgerEntry.SetRange("Posting Date", 20260101D, 20261231D);
        AddExcelLinesCostesProductosDetail(ExcelBuffer, Item, ItemLedgerEntry);
        ExcelBuffer.NewRow;
    end;

    local procedure AddExcelLinesCostesProductosDetail(var ExcelBuffer: Record "Excel Buffer" temporary; Item: Record Item; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        Cantidad: Decimal;
        CosteFactura: Decimal;
        CosteFleteFactura: Decimal;
        CosteFlete: Decimal;
        CosteMovimiento: Decimal;
    begin
        if ItemLedgerEntry.FindFirst() then
            repeat
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                CosteMovimiento += ItemLedgerEntry."Cost Amount (Actual)";
                Cantidad += ItemLedgerEntry.Quantity;
                UpdateValueEntry(ItemLedgerEntry, CosteFactura, CosteFleteFactura, CosteFlete);
            until ItemLedgerEntry.Next() = 0;

        ExcelBuffer.AddColumn(format(Cantidad), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(CosteFactura), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(CosteFleteFactura), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(CosteFlete), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(CosteMovimiento), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure UpdateValueEntry(ItemLedgerEntry: Record "Item Ledger Entry"; var CosteFactura: Decimal; var CosteFleteFactura: Decimal; var CosteFlete: Decimal)
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        if ValueEntry.FindFirst() then
            repeat
                case ValueEntry."Item Charge No." of
                    '':
                        begin
                            CosteFactura += ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)";
                        end;
                    else begin
                        if ValueEntry."Source No." = ItemLedgerEntry."Source No." then begin
                            CosteFleteFactura += ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)";
                        end else begin
                            CosteFlete += ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)";
                        end;
                    end;
                end;

            until ValueEntry.Next() = 0;
    end;
}