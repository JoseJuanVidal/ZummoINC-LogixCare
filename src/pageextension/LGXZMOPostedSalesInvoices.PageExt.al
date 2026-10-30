pageextension 50041 "LGX ZMO Posted Sales Invoices" extends "Posted Sales Invoices" //143
{
    layout
    {
        addbefore("Sell-to Post Code")
        {
            field("Sell-to City"; "Sell-to City")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("Sell-to County"; "Sell-to County")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        // Antes en Zummo Ext WARRANTY (pageextension 50068)
        addlast(Control1)
        {
            field("Service & Warranty No."; "Service & Warranty No.")
            { }
        }
    }

    actions
    {
        // Antes en Zummo Ext WARRANTY (pageextension 50068)
        addlast(Processing)
        {
            action("Assing Warranty & Services")
            {
                Image = WarrantyLedger;

                trigger OnAction()
                begin
                    AssingWarrantyServices();
                end;

            }
            action("Warranties Excel")
            {
                Image = Excel;

                trigger OnAction()
                begin
                    WarrantiesServiceExcel;
                end;
            }
        }
    }

    local procedure AssingWarrantyServices()
    var
        EventSubscriber: Codeunit "ZM Event Suscriber";
    begin
        EventSubscriber.AssingWarrantyServices(Rec."No.")
    end;

    local procedure WarrantiesServiceExcel()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        Functiones: Codeunit "ZM Event Suscriber";
        lblConfirm: Label 'Do you want to export invoices and warranties %1 invoices selected?';
    begin
        CurrPage.SetSelectionFilter(SalesInvHeader);
        if Confirm(lblConfirm, false, SalesInvHeader.Count) then
            Functiones.ExportSerViceItemLine(SalesInvHeader);
    end;
}
