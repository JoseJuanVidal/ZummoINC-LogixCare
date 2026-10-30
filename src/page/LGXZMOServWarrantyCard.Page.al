page 50001 "LGX ZMO Serv. & Warranty Card"
{
    Caption = 'Service & Warranty';
    PageType = Document;
    SourceTable = "LGX ZMO Service & Warranty Hdr";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = PageEditable;

                field("Incident No."; "LGX ZMO Incident No.")
                {
                    ApplicationArea = LGXZMOFunctionality;

                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Status; "LGX ZMO Status")
                {
                    ApplicationArea = LGXZMOFunctionality;

                    trigger OnValidate();
                    begin
                        if "LGX ZMO Status" = "LGX ZMO Status"::Closed then
                            if CONFIRM('Are You Absolutely Sure To Close The Ticket %1', TRUE, "LGX ZMO Incident No.") then
                                PageEditable := NOT ("LGX ZMO Status" = "LGX ZMO Status"::Closed);
                    end;
                }
                field("Item No"; "LGX ZMO Item No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Serial No."; "LGX ZMO Serial No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Purchase Date"; "LGX ZMO Purchase Date")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sales Shipment No."; "LGX ZMO Sales Shipment No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Action Taken"; "LGX ZMO Action Taken")
                {
                    ApplicationArea = LGXZMOFunctionality;

                    trigger OnValidate();
                    begin
                        ActionsReplaced := ("LGX ZMO Action Taken" = "LGX ZMO Action Taken"::Replaced);
                    end;
                }
                field("New Serial No."; "LGX ZMO New Serial No.")
                {
                    Editable = ActionsReplaced;
                    ApplicationArea = LGXZMOFunctionality;
                }
                field(Warranty; "LGX ZMO Warranty")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
            part(IncidentLines; "LGX ZMO Service & Warr. Line")
            {
                SubPageLink = "LGX ZMO Incident No." = field("LGX ZMO Incident No.");
                SubPageView = sorting("LGX ZMO Incident No.", "LGX ZMO Line No.");
                ApplicationArea = LGXZMOFunctionality;
            }
            part(CommentLines; "LGX ZMO Service Warr. Comments")
            {
                SubPageLink = "LGX ZMO No." = field("LGX ZMO Incident No.");
                SubPageView = sorting("LGX ZMO Table Name", "LGX ZMO No.", "LGX ZMO Line No.");
                ApplicationArea = LGXZMOFunctionality;
            }
            group("Item Info")
            {
                Editable = PageEditable;

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
            }
            group("Customer Info")
            {
                Editable = PageEditable;

                field("Sell-To Customer No."; "LGX ZMO Sell-To Customer No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Customer Name"; "LGX ZMO Sell-to Customer Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Customer Name 2"; "LGX ZMO Sell-to Cust. Name 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Address"; "LGX ZMO Sell-to Address")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Address 2"; "LGX ZMO Sell-to Address 2")
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
                field("Sell-to Country/Region Code"; "LGX ZMO Sell-to C./R. Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Sell-to Contact"; "LGX ZMO Sell-to Contact")
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
            }
            group("Purchase Info")
            {
                Editable = PageEditable;
                field("Purchase Receipt No."; "LGX ZMO Purchase Receipt No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Vendor No."; "LGX ZMO Vendor No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Vendor Name"; "LGX ZMO Vendor Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
            group("Shipping Info")
            {
                Editable = PageEditable;
                Visible = false;

                field("Package Tracking No."; "LGX ZMO Package Tracking No.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Code"; "LGX ZMO Ship-to Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Name"; "LGX ZMO Ship-to Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Name 2"; "LGX ZMO Ship-to Name 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Address"; "LGX ZMO Ship-to Address")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Address 2"; "LGX ZMO Ship-to Address 2")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to City"; "LGX ZMO Ship-to City")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Contact"; "LGX ZMO Ship-to Contact")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Post Code"; "LGX ZMO Ship-to Post Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to County"; "LGX ZMO Ship-to County")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Ship-to Country/Region Code"; "LGX ZMO Ship-to C./R. Code")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
                field("Shipment Date"; "LGX ZMO Shipment Date")
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
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Services & Warranty")
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'Services & Warranty';
                Image = "Report";
                Promoted = false;
                RunObject = Report "LGX ZMO Services & Warranty";
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        PageEditable := not ("LGX ZMO Status" = "LGX ZMO Status"::Closed);
    end;

    var
        ActionsReplaced: Boolean;
        PageEditable: Boolean;
}
