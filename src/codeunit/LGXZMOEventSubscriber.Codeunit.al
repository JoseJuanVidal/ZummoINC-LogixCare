codeunit 50000 "LGX ZMO Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure LGXZMOOnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            Report::"Aged Accounts Receivable":
                NewReportId := Report::"LGX ZMO Aged Acc. Receivable";
            Report::"Inventory Movement":
                NewReportId := Report::"LGX ZMO Inventory Movement";
            Report::"Customer Listing":
                NewReportId := Report::"LGX ZMO Customer Listing";
            Report::"Item List":
                NewReportId := Report::"LGX ZMO Item List";
            Report::"Item Register":
                NewReportId := Report::"LGX ZMO Item Register";
            Report::"Item Sales by Customer":
                NewReportId := Report::"LGX ZMO Item Sales by Customer";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure LGXZMOCalcUnitPriceAfterDisc(SalesLine: Record "Sales Line")
    begin
        Clear(SalesLine."LGX ZMO Unit Price After Disc.");
        SalesLine."LGX ZMO Unit Price After Disc." := SalesLine."Unit Price" - (SalesLine."Unit Price" * (SalesLine."Line Discount %" / 100));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure LGXZMOOnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."LGX ZMO Service & Warranty No." := PurchaseHeader."LGX ZMO Service & Warranty No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeReleaseTransferDoc', '', false, false)]
    local procedure LGXZMOOnBeforeReleaseTransferOrder(var TransferHeader: Record "Transfer Header");
    begin
        if TransferHeader."Transfer-to Code" = 'DEMO' then
            TransferHeader.TestField("LGX ZMO Due Date");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure LGXZMOOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."LGX ZMO Comments" := ItemJournalLine."LGX ZMO Comments";
    end;

    procedure SalesDocCheckExtDoc(SalesHeader: Record "Sales Header");
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Error55000Err: Label 'This External Document No. already exists on a posted document.\Document Type: %1\Document No. %2.';
        Error55001Err: Label 'This External Document No. already exists on Sales %1  No. %2.';
    begin
        if (SalesHeader."External Document No." <> '') and
           (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then begin
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetCurrentKey("External Document No.");
            CustLedgerEntry.SetRange("External Document No.", SalesHeader."External Document No.");
            CustLedgerEntry.SetFilter("Customer No.", '%1|%2', SalesHeader."Sell-to Customer No.", SalesHeader."Bill-to Customer No.");
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
            if not CustLedgerEntry.IsEmpty() then
                SalesHeader.FieldError("External Document No.", StrSubstNo(Error55000Err, CustLedgerEntry."Document Type", CustLedgerEntry."Document No."));

            SalesHeader.Reset();
            SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
            SalesHeader.SetFilter("No.", '<>%1', SalesHeader."No.");
            SalesHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            SalesHeader.SetRange("External Document No.", SalesHeader."External Document No.");
            if not SalesHeader.IsEmpty() then
                SalesHeader.FieldError("External Document No.", StrSubstNo(Error55001Err, SalesHeader."Document Type", SalesHeader."No."));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure SalesHeaderOnAfterValidateExtDocNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer);
    begin
        Case CurrFieldNo of
            Rec.FieldNo("External Document No."):
                SalesDocCheckExtDoc(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure SalesReleaseOnBeforeRelease(var SalesHeader: Record "Sales Header");
    begin
        CheckSalesOrderReleaseReqs(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure LGXZMOGenJnlPostLineOnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
    begin
        if not (CustLedgerEntry."Document Type" in [CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo"]) then
            exit;

        if not Customer.Get(CustLedgerEntry."Customer No.") then
            exit;

        if not Customer."LGX ZMO CESCE" then
            exit;

        CustLedgerEntry."LGX ZMO CESCE" := Customer."LGX ZMO CESCE";
        CustLedgerEntry."LGX ZMO CESCE Cr. Limit" := Customer."LGX ZMO CESCE Cr. Limit";
        CustLedgerEntry."LGX ZMO CESCE No." := Customer."LGX ZMO CESCE No.";
    end;

    local procedure CheckSalesOrderReleaseReqs(var SalesHeader: Record "Sales Header");
    begin
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesHeader.TestField("Package Tracking No.");
    end;
}

