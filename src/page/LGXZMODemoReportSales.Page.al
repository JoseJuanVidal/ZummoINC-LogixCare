page 50010 "LGX ZMO Demo Report - Sales"
{
    Caption = 'Demo Report - Sales';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      where("Entry Type" = const(Sale),
                            "Document Type" = filter("Sales Invoice" | "Sales Shipment"),
                            "Location Code" = filter('DEMO'));
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Caption = 'Starting Date Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate();
                    var
                        ApplicationMgt: Codeunit TextManagement;
                    begin
                        if ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid();
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Caption = 'Sales Code Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        CustList: Page "Customer List";

                    begin
                        CustList.LookupMode := true;
                        if CustList.RunModal() = ACTION::LookupOK then
                            Text := CustList.GetSelectionFilter()
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate();
                    begin
                        SalesCodeFilterOnAfterValidate();
                    end;
                }
                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := TRUE;
                        if ItemList.RunModal() = ACTION::LookupOK then
                            Text := ItemList.GetSelectionFilter()
                        ELSE
                            EXIT(false);

                        EXIT(true);
                    end;

                    trigger OnValidate();
                    begin
                        ItemNoFilterOnAfterValidate();
                    end;
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                Visible = false;
                field("Filter Description"; GetFilterDescription())
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Editable = false;
                    ToolTip = 'Specifies a filter for which sales prices to display.';
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("Date Of Sale"; SalesInvoiceHeader."Posting Date")
                {
                }
                field(Name; SalesInvoiceHeader."Sell-to Customer Name")
                {
                }
                field(Address; SalesInvoiceHeader."Sell-to Address" + ' ' + SalesInvoiceHeader."Sell-to Address 2")
                {
                }
                field("Zip Code"; SalesInvoiceHeader."Sell-to Post Code")
                {
                }
                field(City; SalesInvoiceHeader."Sell-to City")
                {
                }
                field(State; SalesInvoiceHeader."Sell-to County")
                {
                }
                field("Invoice No."; SalesInvoiceHeader."No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; Item.Description + ' ' + Item."Description 2")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Serial No."; "Serial No.")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Content)
            {
                action("Export To Excel")
                {
                    Image = Excel;
                    trigger OnAction();
                    begin
                        ExportToExcel();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        GetHeaderDetails("Document No.");
        GetItemDetails("Item No.");
    end;

    trigger OnClosePage();
    begin
        ExcelBuf.DeleteAll();
    end;

    trigger OnOpenPage();
    begin
        ExcelBuf.DeleteAll();

        GetRecFilters();
        SetRecFilters();
    end;

    var
        Cust: Record "Customer";
        Item: Record "Item";
        ExcelBuf: Record "Excel Buffer" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesCodeFilter: Text;
        ItemNoFilter: Text;
        StartingDateFilter: Text;
        Text000Txt: Label 'All Customers';
        Text001Txt: Label 'No %1 within the filter %2.';


    local procedure GetHeaderDetails(DocumentNo: Code[20]);
    begin
        Clear(SalesShipmentHeader);
        if SalesShipmentHeader.Get(DocumentNo) then begin
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetFilter("Order No.", SalesShipmentHeader."Order No.");
            if SalesInvoiceHeader.FindFirst() then;
        end;
    end;

    local procedure GetItemDetails(ItemNo: Code[20]);
    begin
        Clear(Item);
        if Item.GET(ItemNo) then;
    end;

    local procedure ExportToExcel();
    begin
        ExcelBuf.DeleteAll();
        ExcelBuf.Reset();
        MakeExcelDataHeader();
        MakeExcelDataBody();
        CreateExcelbook();
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Date of Sales', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Address', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Zip Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('City', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('State', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Requisition Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Serial No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody();
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record "Item";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.CopyFilters(Rec);
        if ItemLedgerEntry.FindSet() then
            repeat

                Clear(Item);
                if Item.GET(ItemLedgerEntry."Item No.") then;

                Clear(SalesShipmentHeader);
                if SalesShipmentHeader.GET(ItemLedgerEntry."Document No.") then begin
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetFilter("Order No.", SalesShipmentHeader."Order No.");
                    if SalesInvoiceHeader.FindFirst() then;
                end;

                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(SalesInvoiceHeader."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Address" + ' ' + SalesInvoiceHeader."Sell-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to City", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."Sell-to County", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(SalesInvoiceHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(ItemLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(ItemLedgerEntry."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item.Description + ' ' + Item."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(ItemLedgerEntry.Quantity, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ItemLedgerEntry."Serial No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure CreateExcelbook();
    begin
        ExcelBuf.CreateNewBook(CopyStr('Demo Report', 1, 250));
        ExcelBuf.WriteSheet('Demo Report', CompanyName(), UserId());
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;

    local procedure SalesCodeFilterOnAfterValidate();
    begin
        CurrPage.SaveRecord();
        SetRecFilters();
    end;

    local procedure StartingDateFilterOnAfterValid();
    begin
        CurrPage.SaveRecord();
        SetRecFilters();
    end;

    local procedure ItemNoFilterOnAfterValidate();
    begin
        CurrPage.SaveRecord();
        SetRecFilters();
    end;

    local procedure SetRecFilters();
    begin
        if SalesCodeFilter <> '' then
            SetFilter("Source No.", SalesCodeFilter)
        ELSE
            SetRange("Source No.");

        if StartingDateFilter <> '' then
            SetFilter("Posting Date", StartingDateFilter)
        ELSE
            SetRange("Posting Date");

        if ItemNoFilter <> '' then
            SetFilter("Item No.", ItemNoFilter)
        else
            SetRange("Item No.");

        CheckFilters(DATABASE::Customer, SalesCodeFilter);
        CheckFilters(DATABASE::Item, ItemNoFilter);

        CurrPage.UPDATE(FALSE);
    end;

    local procedure CheckFilters(TableNo: Integer; FilterTxt: Text);
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        if FilterTxt = '' then
            exit;
        Clear(FilterRecordRef);
        Clear(FilterFieldRef);
        FilterRecordRef.OPEN(TableNo);
        FilterFieldRef := FilterRecordRef.FIELD(1);
        FilterFieldRef.SetFilter(FilterTxt);
        if FilterRecordRef.IsEmpty() then
            ERROR(Text001Txt, FilterRecordRef.Caption(), FilterTxt);
    end;

    local procedure GetCaption(): Text;
    begin
        EXIT(GetFilterDescription());
    end;

    local procedure GetFilterDescription(): Text;
    var
        ObjTranslation: Record "Object Translation";
        SourceTableName: Text;
        SalesSrcTableName: Text;
        Description: Text;
    begin
        GetRecFilters();

        SourceTableName := '';
        if ItemNoFilter <> '' then
            SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table, 27);

        SalesSrcTableName := '';
        begin
            SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table, 18);
            Cust."No." := CopyStr(SalesCodeFilter, 1, MaxStrLen(Cust."No."));
            if Cust.Find() then
                Description := Cust.Name;
        end;

        if SalesSrcTableName = Text000Txt then
            EXIT(StrSubstNo('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
        EXIT(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, ItemNoFilter));
    end;

    local procedure GetRecFilters();
    begin
        if GetFilters() <> '' then
            UpdateBasicRecFilters();

        EVALUATE(StartingDateFilter, GETFILTER("Posting Date"));
    end;

    local procedure FilterLines();
    var
        FilterPageBuilder: FilterPageBuilder;
    begin
        FilterPageBuilder.SetView(TableCaption(), GetView());

        if GetFilter("Source No.") = '' then
            FilterPageBuilder.ADDFIELDNO(TableCaption(), FIELDNO("Source No."));
        if GetFilter("Item No.") = '' then
            FilterPageBuilder.ADDFIELDNO(TableCaption(), FIELDNO("Item No."));
        if GetFilter("Posting Date") = '' then
            FilterPageBuilder.ADDFIELDNO(TableCaption(), FIELDNO("Posting Date"));

        if FilterPageBuilder.RunModal() then
            SetView(FilterPageBuilder.GetView(TableCaption()));

        UpdateBasicRecFilters();
        EVALUATE(StartingDateFilter, GetFilter("Posting Date"));
    end;

    local procedure UpdateBasicRecFilters();
    begin
        SalesCodeFilter := GETFILTER("Source No.");
        ItemNoFilter := GETFILTER("Item No.");
    end;
}

