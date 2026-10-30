pageextension 50040 "LGX ZMO Sales Order List" extends "Sales Order List" //9305
{
    layout
    {
        addbefore(Amount)
        {
            field("Outstanding Amount ($)"; "Outstanding Amount ($)")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
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