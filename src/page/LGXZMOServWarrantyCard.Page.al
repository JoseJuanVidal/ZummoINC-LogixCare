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
                // Antes en Zummo Ext WARRANTY (pageextension 50063)
                field("LGX ZMO Incident Date"; "LGX ZMO Incident Date")
                {
                    ApplicationArea = All;
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
                // Antes en Zummo Ext WARRANTY (pageextension 50063)
                field("Parts/Machine"; "Parts/Machine")
                {
                    ApplicationArea = All;
                }
                field("Actiont Type"; "Actiont Type")
                {
                    ApplicationArea = all;
                }
                field("Service & Warranty Associated"; "Service & Warranty Associated")
                {
                    ApplicationArea = All;
                }
                field(Resolution; Resolution)
                {
                    ApplicationArea = All;
                }
                field("Technical Visit"; "Technical Visit")
                {
                    ApplicationArea = all;
                }
                field("Service Type"; "Service Type")
                {
                    ApplicationArea = all;
                }
                field(Fault; Fault)
                {
                    ApplicationArea = All;
                }
                field("Localized Fault"; "Localized Fault")
                {
                    ApplicationArea = All;
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

                    // Antes en Zummo Ext WARRANTY (pageextension 50063)
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Customer: Record Customer;
                        Customers: page "Customer List";
                    begin
                        Customers.LookupMode := true;
                        if Customers.RunModal() = Action::LookupOK then begin
                            Customers.GetRecord(Customer);
                            Rec.Validate("LGX ZMO Sell-To Customer No.", Customer."No.");

                            UpdateCustomerNo();
                        end;
                    end;
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
            // Antes en Zummo Ext WARRANTY (pageextension 50063)
            group(ShipTo)
            {
                Caption = 'Ship - To';

                field("LGX ZMO Ship-to Name"; "LGX ZMO Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("LGX ZMO Ship-to Address"; "LGX ZMO Ship-to Address")
                {
                    ApplicationArea = all;
                }
                field("LGX ZMO Ship-to City"; "LGX ZMO Ship-to City")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        PostCode: record "Post Code";
                    begin
                        if Rec."LGX ZMO Ship-to Post Code" <> '' then
                            exit;
                        PostCode.SetRange(City, Rec."LGX ZMO Ship-to City");
                        if PostCode.FindFirst() then
                            Rec."LGX ZMO Ship-to Post Code" := PostCode.code;
                    end;
                }
                field("LGX ZMO Ship-to County"; "LGX ZMO Ship-to County")
                {
                    ApplicationArea = all;
                }
                field("LGX ZMO Ship-to Post Code"; "LGX ZMO Ship-to Post Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        PostCode: record "Post Code";
                    begin
                        if Rec."LGX ZMO Ship-to City" <> '' then
                            exit;
                        PostCode.SetRange(code, Rec."LGX ZMO Ship-to Post Code");
                        if PostCode.FindFirst() then
                            Rec."LGX ZMO Ship-to City" := PostCode.City;
                    end;
                }
                field("LGX ZMO Ship-to C./R. Code"; "LGX ZMO Ship-to C./R. Code")
                {
                    ApplicationArea = all;
                }
                field("LGX ZMO Ship-to Contact"; "LGX ZMO Ship-to Contact")
                {
                    ApplicationArea = all;
                }
                field("LGX ZMO Ship-to E-Mail"; "LGX ZMO Ship-to E-Mail")
                {
                    ApplicationArea = All;
                }
                field("LGX ZMO Sell-to Phone No."; "LGX ZMO Sell-to Phone No.")
                {
                    ApplicationArea = All;
                }
            }
            group(WarrantyServicesInfo)
            {
                Caption = 'Warranty & Services Info';
                Visible = false;
                group(Charges)
                {
                    field("Shipphing Method"; "Shipphing Method")
                    {
                        ApplicationArea = All;
                    }
                    field("Labor Hours Fees"; "Labor Hours Fees")
                    {
                        ApplicationArea = All;
                    }
                    field("Travel Hours Fees"; "Travel Hours Fees")
                    {
                        ApplicationArea = All;
                    }
                    field("Credit Card Fees"; "Credit Card Fees")
                    {
                        ApplicationArea = All;
                    }
                    field("Rush Fees"; "Rush Fees")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Amounts)
                {
                    field("Items Amount"; "Items Amount")
                    {
                        ApplicationArea = All;
                    }
                    field(Taxes; Taxes)
                    {
                        ApplicationArea = All;
                    }
                    field(DiscountPorc; DiscountPorc)
                    {
                        ApplicationArea = All;
                    }
                    field("Amount Discount"; "Amount Discount")
                    {
                        ApplicationArea = All;
                    }
                    field(Total; Rec.GetTotals())
                    {
                        ApplicationArea = All;
                        Editable = False;
                    }
                }
            }
            group("Head Quarter")
            {

                Visible = UserHQ;
                field(Response; Response)
                { }
                field("Service Order"; "Service Order")
                { }
                field("Credit Memo No."; "Credit Memo No.")
                { }
                field("Cost Total"; "Cost Total")
                { }
                field("Response Text"; "Response Text")
                {
                    Caption = 'Comments';
                    ApplicationArea = all;
                    MultiLine = true;
                    Editable = false;
                }
                group("Posting Dates")
                {
                    field("Create Date-Time"; "Create Date-Time")
                    {
                        ApplicationArea = all;
                    }
                    field("Sent Quote Date-Time"; "Sent Quote Date-Time")
                    {
                        ApplicationArea = All;
                    }
                    field("Orders Date-Time"; "Orders Date-Time")
                    {
                        ApplicationArea = all;
                    }
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
        // Antes en Zummo Ext WARRANTY (pageextension 50063)
        area(factboxes)
        {
            part("W&S Doc. Attachment Factbox"; "W&S Doc. Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Documents';
                SubPageLink = "No." = field("LGX ZMO Incident No."), TypeDoc = const(" ");
            }
            part(DocAttachmentFactbox; "W&S Doc. Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Custome Documents';
                SubPageLink = "No." = field("LGX ZMO Incident No."), TypeDoc = const(Customer);
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
        // Antes en Zummo Ext WARRANTY (pageextension 50063)
        area(processing)
        {
            action(OpenWarrantyInfo)
            {
                ApplicationArea = All;
                Caption = 'Create Order';
                Image = Order;
                promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WarrantyServHdr: Record "LGX ZMO Service & Warranty Hdr";
                    ServWarrInfo: page "Warranty & Service Items Hdr";
                begin
                    WarrantyServHdr.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
                    ServWarrInfo.SetTableView(WarrantyServHdr);
                    ServWarrInfo.Run();
                end;
            }
            action(CopyAddress)
            {
                ApplicationArea = All;
                Caption = 'Copy Address Shipp-To';
                // Visible = not SeleccServWarrant;
                Image = UpdateShipment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CopyAddresstoShipto();
                end;
            }
        }
        area(navigation)
        {
            action("Attachment documents")
            {
                ApplicationArea = All;
                Caption = 'Attachment Documents';
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WarrServiceDocAttach: page "ZM Warr. & Service Doc Attach";
                begin
                    UnlikedAttachment.Reset();
                    WarrServiceDocAttach.SetRecNo(Rec."LGX ZMO Incident No.", UnlikedAttachment.TypeDoc::Customer);
                    UnlikedAttachment.SetRange("No.", Rec."LGX ZMO Incident No.");
                    WarrServiceDocAttach.SetTableView(UnlikedAttachment);
                    WarrServiceDocAttach.RunModal();
                end;
            }
            action(SalesQuotes)
            {
                Caption = 'Sales Quotes';
                Image = Quote;
                trigger OnAction()
                var
                    SalesQuotes: page "Sales Quotes";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
                    SalesHeader.SetFilter("Service & Warranty No.", '%1', StrSubstNo('%1*', Rec."LGX ZMO Incident No."));
                    SalesQuotes.SetTableView(SalesHeader);
                    SalesQuotes.Run();
                end;
            }
            action(SalesOrder)
            {
                Caption = 'Sales Orders';
                Image = Order;
                RunObject = page "Sales Order List";
                RunPageLink = "Service & Warranty No." = field("LGX ZMO Incident No.");

                trigger OnAction()
                var
                    SalesOrderList: page "Sales Order List";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetFilter("Service & Warranty No.", '%1', StrSubstNo('%1*', Rec."LGX ZMO Incident No."));
                    SalesOrderList.SetTableView(SalesHeader);
                    SalesOrderList.Run();
                end;
            }
            action(SalesInvoice)
            {
                Caption = 'Sales Invoice';
                Image = SalesInvoice;

                trigger OnAction()
                var
                    SalesOrderList: page "Posted Sales Invoices";
                begin
                    SalesInvoiceHdr.Reset();
                    SalesInvoiceHdr.SetFilter("Service & Warranty No.", '%1', StrSubstNo('%1*', Rec."LGX ZMO Incident No."));
                    SalesOrderList.SetTableView(SalesHeader);
                    SalesOrderList.Run();
                end;
            }
            action(PurchaseInvoice)
            {
                Caption = 'Purchase Invoice';
                Image = PurchaseInvoice;

                trigger OnAction()
                var
                    PurchOrderList: page "Posted Purchase Invoices";
                begin
                    PurchInvHeader.Reset();
                    PurchInvHeader.SetFilter("LGX ZMO Service & Warranty No.", '%1', StrSubstNo('%1*', Rec."LGX ZMO Incident No."));
                    PurchOrderList.SetTableView(PurchInvHeader);
                    PurchOrderList.Run();
                end;
            }
        }
    }

    // Antes en Zummo Ext WARRANTY (pageextension 50063)
    trigger OnOpenPage()
    begin
        if Rec.UserPermissionsstatistics then
            UserHQ := true;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        PageEditable := not ("LGX ZMO Status" = "LGX ZMO Status"::Closed);
        // Antes en Zummo Ext WARRANTY (pageextension 50063)
        CurrPage."W&S Doc. Attachment Factbox".page.SetRecNo(Rec."LGX ZMO Incident No.", UnlikedAttachment.TypeDoc::" ");
        CurrPage.DocAttachmentFactbox.page.SetRecNo(Rec."LGX ZMO Incident No.", UnlikedAttachment.TypeDoc::Customer);
    end;

    var
        ActionsReplaced: Boolean;
        PageEditable: Boolean;
        // Antes en Zummo Ext WARRANTY (pageextension 50063)
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        UnlikedAttachment: Record "Unlinked Attachment";
        Amount: Decimal;
        UserHQ: Boolean;

    local procedure UpdateCustomerNo()
    var
        CustShiptoAddress: Record "Ship-to Address";
    begin
        if not Customer.Get(Rec."LGX ZMO Sell-To Customer No.") then
            exit;
        // TAX LIABLE
        Rec.Taxes := Customer."Tax Liable";
        // SHELL-TO
        Rec."LGX ZMO Sell-to Customer Name" := Customer.Name;
        Rec."LGX ZMO Sell-to Cust. Name 2" := Customer."Name 2";
        Rec."LGX ZMO Sell-to Address" := Customer.Address;
        Rec."LGX ZMO Sell-to Address 2" := Customer."Address 2";
        Rec."LGX ZMO Sell-to City" := Customer.City;
        Rec."LGX ZMO Sell-to Post Code" := Customer."Post Code";
        Rec."LGX ZMO Sell-to County" := Customer.County;
        Rec."LGX ZMO Sell-to C./R. Code" := Customer."Country/Region Code";
        Rec."LGX ZMO Sell-to Contact" := Customer.Contact;
        Rec."LGX ZMO Sell-to E-Mail" := Customer."E-Mail";
        Rec."LGX ZMO Sell-to Phone No." := Customer."Phone No.";
        Rec."LGX ZMO Sell-to Fax No." := Customer."Fax No.";
        // SHIP-TO
        if not CustShiptoAddress.Get(Customer."No.", Customer."Ship-to Code") then
            exit;
        Rec."LGX ZMO Ship-to Code" := Customer."Ship-to Code";
        Rec."LGX ZMO Ship-to Name" := CustShiptoAddress.Name;
        Rec."LGX ZMO Ship-to Name 2" := CustShiptoAddress."Name 2";
        Rec."LGX ZMO Ship-to Address" := CustShiptoAddress.Address;
        Rec."LGX ZMO Ship-to Address 2" := CustShiptoAddress."Address 2";
        Rec."LGX ZMO Ship-to City" := CustShiptoAddress.City;
        Rec."LGX ZMO Ship-to Post Code" := CustShiptoAddress."Post Code";
        Rec."LGX ZMO Ship-to County" := CustShiptoAddress.County;
        Rec."LGX ZMO Ship-to C./R. Code" := CustShiptoAddress."Country/Region Code";
        Rec."LGX ZMO Ship-to Contact" := CustShiptoAddress.Contact;
        Rec."LGX ZMO Ship-to E-Mail" := CustShiptoAddress."E-Mail";
        Rec."LGX ZMO Ship-to Phone" := CustShiptoAddress."Phone No.";

    end;
}
