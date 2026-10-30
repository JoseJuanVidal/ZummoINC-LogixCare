pageextension 50027 "LGX ZMO Posted Purchase Inv." extends "Posted Purchase Invoices" //146
{
    layout
    {
        addafter("Order No.")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        // Antes en Zummo Ext WARRANTY (pageextension 50062)
        addafter(Corrective)
        {
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = all;
            }
            field("LGX ZMO Service & Warranty No."; "LGX ZMO Service & Warranty No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        // Antes en Zummo Ext WARRANTY (pageextension 50062)
        addlast(Processing)
        {
            action(ExportarCostes)
            {
                ApplicationArea = All;
                Caption = 'Exportar Costes';
                Image = ExportToExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    EventSubs: Codeunit "ZM Event Suscriber";
                begin
                    if Confirm('Desea Exportar los costes de los productos?') then
                        EventSubs.ExportAnalisisCostesProductos();
                end;
            }
        }
    }
}
