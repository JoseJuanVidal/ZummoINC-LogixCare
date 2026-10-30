page 50002 "LGX ZMO Service & Warr. Line"
{
    Caption = 'Service & Warranty Line';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "LGX ZMO Service & Warr. Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assisted By"; "LGX ZMO Assisted By")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Service; "LGX ZMO Service")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Package Tracking No."; "LGX ZMO Package Tracking No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Scheduled  Delivery Date"; "LGX ZMO Schd. Delivery Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Estimated Delivery Date"; "LGX ZMO Est. Delivery Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Actual Delivery Date"; "LGX ZMO Actual Delivery Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Left At"; "LGX ZMO Left At")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Received By"; "LGX ZMO Received By")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Shipment Method Code"; "LGX ZMO Shipment Method Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Shipping Agent Code"; "LGX ZMO Shipping Agent Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Shipment Return"; "LGX ZMO Shipment Return")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Reason Code"; "LGX ZMO Reason Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Remarks; "LGX ZMO Remarks")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company No."; "LGX ZMO Service Company No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Name"; "LGX ZMO Service Company Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Name 2"; "LGX ZMO Service Company Name 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Visible = false;
                }
                field("Service Company Address"; "LGX ZMO Serv. Company Address")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Address 2"; "LGX ZMO Serv. Company Addr. 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Visible = false;
                }
                field("Service Company City"; "LGX ZMO Service Company City")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Post Code"; "LGX ZMO Serv. Comp. Post Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company County"; "LGX ZMO Service Company County")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Country Code"; "LGX ZMO Serv. Comp. Ctry. Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Contact"; "LGX ZMO Serv. Company Contact")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Phone No."; "LGX ZMO Serv. Comp. Phone No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Fax No."; "LGX ZMO Serv. Comp. Fax No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    Visible = false;
                }
                field("Service Company E-Mail"; "LGX ZMO Service Company E-Mail")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Service Company Invoice No."; "LGX ZMO Serv. Comp. Inv. No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Cycles; "LGX ZMO Cycles")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Courtesy Part"; "LGX ZMO Courtesy Part")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
        }
    }

    // Antes en Zummo Ext WARRANTY (pageextension 50073)
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.UpdateAssitedBy();
    end;
}
