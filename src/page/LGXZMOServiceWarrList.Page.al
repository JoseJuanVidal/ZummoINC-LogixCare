page 50003 "LGX ZMO Service & Warr. List"
{
    Caption = 'Services & Warranties';
    CardPageID = "LGX ZMO Serv. & Warranty Card";
    Editable = false;
    PageType = List;
    SourceTable = "LGX ZMO Service & Warranty Hdr";
    UsageCategory = Lists;
    ApplicationArea = LGXZMOFunctionality;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident No."; "LGX ZMO Incident No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Item No."; "LGX ZMO Item No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Item Description"; "LGX ZMO Item Description")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Item Description 2"; "LGX ZMO Item Description 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Serial No."; "LGX ZMO Serial No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sales Shipment No."; "LGX ZMO Sales Shipment No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Purchase Date"; "LGX ZMO Purchase Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Incident Date"; "LGX ZMO Incident Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Warranty; "LGX ZMO Warranty")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Action Taken"; "LGX ZMO Action Taken")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Customer Name"; "LGX ZMO Sell-to Customer Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Address"; "LGX ZMO Sell-to Address")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to City"; "LGX ZMO Sell-to City")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Post Code"; "LGX ZMO Sell-to Post Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to County"; "LGX ZMO Sell-to County")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Phone No."; "LGX ZMO Sell-to Phone No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Fax No."; "LGX ZMO Sell-to Fax No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to E-Mail"; "LGX ZMO Sell-to E-Mail")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Status; "LGX ZMO Status")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Services & Warranty")
            {
                Caption = 'Services & Warranty';
                Image = "Report";
                Promoted = false;
                RunObject = Report "LGX ZMO Services & Warranty";
            }
        }
    }
}
