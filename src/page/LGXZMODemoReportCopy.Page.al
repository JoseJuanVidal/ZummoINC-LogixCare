page 50008 "LGX ZMO Demo Report - Copy"
{
    Caption = 'Demo Report - Copy';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    SourceTableView = where("Transfer-to Code" = filter('DEMO'));
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Of Transfer"; TransferShipmentHeader."Shipment Date")
                {
                }
                field(Name; TransferShipmentHeader."Transfer-to Name")
                {
                }
                field(Address; TransferShipmentHeader."Transfer-to Address" + ' ' + TransferShipmentHeader."Transfer-to Address 2")
                {
                }
                field("Zip Code"; TransferShipmentHeader."Transfer-to Post Code")
                {
                }
                field(City; TransferShipmentHeader."Transfer-to City")
                {
                }
                field(State; TransferShipmentHeader."Transfer-to County")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Serial No."; GetSerialNo("Item No.", "Document No."))
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        GetHeaderDetails("Document No.");
    end;

    var
        TransferShipmentHeader: Record "Transfer Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";

    local procedure GetHeaderDetails(DocumentNo: Code[20]);
    begin
        Clear(TransferShipmentHeader);
        IF TransferShipmentHeader.GET(DocumentNo) then;
    end;

    local procedure GetSerialNo(ItemNo: Code[20]; DocumentNo: Code[20]): Code[30];
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Document No.", "Document No.");
        if ItemLedgerEntry.FindFirst() then
            exit(ItemLedgerEntry."Serial No.");
    end;
}

