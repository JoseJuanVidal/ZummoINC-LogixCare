tableextension 50023 "LGX ZMO Sales Cue" extends "Sales Cue" //9053
{
    fields
    {
        field(50000; "LGX ZMO Partially Shipped"; Integer)
        {
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count ("Sales Header" where("Document Type" = filter(Order), Status = filter(Released | Open), Shipped = filter(true), "Completely Shipped" = filter(false), "Responsibility Center" = FIELD("Responsibility Center Filter")));
            AccessByPermission = TableData "Sales Shipment Header" = R;
        }
    }
}