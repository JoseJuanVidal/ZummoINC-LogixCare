page 50009 "LGX ZMO Demo Report - Transfer"
{
    Caption = 'Demo Report - Transfer';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      where("Entry Type" = const(Transfer),
                            "Document Type" = const("Transfer Receipt"),
                            Open = const(true),
                            "Location Code" = filter('DEMO'));
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Of Transfer"; TransferReceiptHeader."Shipment Date")
                {
                }
                field(Name; TransferReceiptHeader."Transfer-to Name")
                {
                }
                field(Address; TransferReceiptHeader."Transfer-to Address" + ' ' + TransferReceiptHeader."Transfer-to Address 2")
                {
                }
                field("Zip Code"; TransferReceiptHeader."Transfer-to Post Code")
                {
                }
                field(City; TransferReceiptHeader."Transfer-to City")
                {
                }
                field(State; TransferReceiptHeader."Transfer-to County")
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
            group(Action)
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
    end;

    var
        Item: Record "Item";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        ExcelBuf: Record "Excel Buffer" temporary;

    local procedure GetHeaderDetails(DocumentNo: Code[20]);
    begin
        Clear(TransferReceiptHeader);
        if TransferReceiptHeader.GET(DocumentNo) then;
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
        ExcelBuf.AddColumn('Date of Transfer', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Address', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Zip Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('City', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('State', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
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
        TransferReceiptHeader: Record "Transfer Receipt Header";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.CopyFilters(Rec);
        if ItemLedgerEntry.FindSet() then
            repeat
                Clear(Item);
                if Item.GET(ItemLedgerEntry."Item No.") then;
                Clear(TransferReceiptHeader);
                if TransferReceiptHeader.GET(ItemLedgerEntry."Document No.") then;

                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(TransferReceiptHeader."Shipment Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TransferReceiptHeader."Transfer-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TransferReceiptHeader."Transfer-to Address" + ' ' + TransferReceiptHeader."Transfer-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TransferReceiptHeader."Transfer-to Post Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TransferReceiptHeader."Transfer-to City", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TransferReceiptHeader."Transfer-to County", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
}

