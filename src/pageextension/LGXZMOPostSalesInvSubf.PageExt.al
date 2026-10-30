pageextension 50021 "LGX ZMO Post. Sales Inv. Subf." extends "Posted Sales Invoice Subform" //133
{
    layout
    {
        addafter("Total Amount Incl. VAT")
        {
            field(LGXZMOPayments; Payments)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Payments';
                AutoFormatType = 1;
                AutoFormatExpression = GetCurrencyCode();
                Editable = false;
                DrillDown = false;
            }
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
        CalcCreditMemoTotal("Document No.", "Sell-to Customer No.");
    end;

    local procedure CalcCreditMemoTotal(DocumentNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
    begin
        RemainingAmt := 0;
        CreditMemoAmt := 0;
        Payments := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", "Document No.", "Closed by Entry No.");
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        if CustLedgerEntry.FindFirst() then begin
            Payments := CustLedgerEntry."Closed by Amount (LCY)";
            CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
            RemainingAmt := CustLedgerEntry."Remaining Amt. (LCY)";
            CustLedgerEntry2.Reset();
            CustLedgerEntry2.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
            if CustLedgerEntry2.FindSet() then
                repeat
                    CreditMemoAmt += CustLedgerEntry2."Closed by Amount (LCY)";
                until CustLedgerEntry2.Next() = 0;
        end;
    end;

    var
        CreditMemoAmt: Decimal;
        RemainingAmt: Decimal;
        Payments: Decimal;
}