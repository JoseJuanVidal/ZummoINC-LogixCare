pageextension 50022 "LGX ZMO Sales & Rec. Setup" extends "Sales & Receivables Setup" //459
{
    layout
    {
        addafter("Direct Debit Mandate Nos.")
        {
            field("LGX ZMO Serv. & Warranty Nos."; "LGX ZMO Serv. & Warranty Nos.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        // Antes en Zummo Ext WARRANTY (pageextension 50064)
        addlast(General)
        {
            field("Maximum Discount"; "Maximum Discount")
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group(Tariff)
            {
                Caption = 'Tariif - Service & Warranty';

                field("G/L Account No. Tariff"; "G/L Account No. Tariff")
                { }
                field("Tariff %"; "Tariff %")
                { }
                field("Tariff Description"; "Tariff Description")
                {
                    ToolTip = 'Text for Tariff Description. %1 Producto No., %2 Description, %3 Tariff percentage';
                }
                group(ServiceWarranty)
                {
                    field("Warr & Serv. Taxes"; "Warr & Serv. Taxes")
                    {
                        ToolTip = 'Indicate the default % of Taxes';
                    }
                    field("G/L Account Shipment"; "G/L Account Shipment")
                    {
                    }
                    field("G/L Account Labor/Travel"; "G/L Account Labor/Travel")
                    {
                    }
                    field("G/L Account Rush Fee"; "G/L Account Rush Fee")
                    {
                    }
                    field("Labors Hours Fees"; "Labors Hours Fees")
                    {
                    }
                    field("Travel Hours Fees"; "Travel Hours Fees")
                    {
                    }
                    field("Operations Email"; "Operations Email")
                    {
                    }
                }
            }
        }
    }
}
