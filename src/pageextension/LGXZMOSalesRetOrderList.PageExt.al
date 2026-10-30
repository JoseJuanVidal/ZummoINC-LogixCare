pageextension 50039 "LGX ZMO Sales Ret. Order List" extends "Sales Return Order List" //9304
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