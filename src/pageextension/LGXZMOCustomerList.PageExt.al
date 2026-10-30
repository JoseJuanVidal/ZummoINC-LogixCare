pageextension 50002 "LGX ZMO Customer List" extends "Customer List" //22
{
    layout
    {
        addlast(Control1)
        {
            field("LGX ZMO CESCE"; "LGX ZMO CESCE")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE No."; "LGX ZMO CESCE No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE Cr. Limit"; "LGX ZMO CESCE Cr. Limit")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }

    actions
    {
        addfirst(SalesReports)
        {
            action(LGXItemSalesByCustomer)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Item Sales By Customer';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Sales;
                RunObject = report "LGX ZMO Item Sales by Cust";
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