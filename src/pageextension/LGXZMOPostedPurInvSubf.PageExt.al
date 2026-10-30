pageextension 50025 "LGX ZMO Posted Pur. Inv. Subf." extends "Posted Purch. Invoice Subform" //139
{
    layout
    {
        addafter("Total Amount Incl. VAT")
        {
            field(LGXZMOAppliedCrMemo; CreditMemoAmt)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Cr. Memo Applied to Inv. (USD)';
                AutoFormatType = 1;
                AutoFormatExpression = GetCurrencyCode();
                Editable = false;
                DrillDown = false;
            }
            field(LGXZMORemainingAmt; RemainingAmt)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Remaining Amount (USD)';
                AutoFormatType = 1;
                AutoFormatExpression = GetCurrencyCode();
                Editable = false;
                DrillDown = false;
                Style = Strong;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcDocumentTotal("Document No.", "Buy-from Vendor No.");
    end;

    local PROCEDURE CalcDocumentTotal(DocumentNo: Code[20]; VendorNo: Code[20]);
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        RemainingAmt := 0;
        CreditMemoAmt := 0;
        Payments := 0;
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetRange("Document No.", DocumentNo);
        if VendorLedgerEntry.FindFirst() then begin
            Payments := VendorLedgerEntry."Closed by Amount (LCY)";
            VendorLedgerEntry.CalcFields("Remaining Amt. (LCY)");
            RemainingAmt := VendorLedgerEntry."Remaining Amt. (LCY)";
            VendorLedgerEntry2.Reset();
            VendorLedgerEntry2.SetRange("Closed by Entry No.", VendorLedgerEntry."Entry No.");
            if VendorLedgerEntry2.FindSet() then
                repeat
                    CreditMemoAmt += VendorLedgerEntry2."Closed by Amount (LCY)";
                until VendorLedgerEntry2.Next() = 0;
        end;
    end;

    var
        CreditMemoAmt: Decimal;
        RemainingAmt: Decimal;
        Payments: Decimal;
}