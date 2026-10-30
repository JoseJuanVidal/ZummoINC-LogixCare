pageextension 50037 "LGX ZMO Sales Credit Memos" extends "Sales Credit Memos" //9302
{
    trigger OnOpenPage()
    var
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        SalesPerson.Reset();
        SalesPerson.SetRange("LGX ZMO SalesPerson User ID", UserId());
        SalesPerson.SetRange("LGX ZMO Set Cust. List Filter", true);
        if SalesPerson.FindFirst() then begin
            FilterGroup(2);
            SetRange("Salesperson Code", SalesPerson.Code);
            FilterGroup(0);
        end;
    end;
}