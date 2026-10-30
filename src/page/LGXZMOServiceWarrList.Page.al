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
                    // Antes en Zummo Ext WARRANTY (pageextension 50065)
                    Style = Unfavorable;
                    StyleExpr = NotCustomerNo;
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
                // Antes en Zummo Ext WARRANTY (pageextension 50065)
                field("LGX ZMO Sell-To Customer No."; "LGX ZMO Sell-To Customer No.")
                {
                    Style = Unfavorable;
                    StyleExpr = NotCustomerNo;
                }
                field("Sell-to Customer Name"; "LGX ZMO Sell-to Customer Name")
                {
                    ApplicationArea = LGXZMOFunctionality;
                    // Antes en Zummo Ext WARRANTY (pageextension 50065)
                    Style = Unfavorable;
                    StyleExpr = NotCustomerNo;
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
                // Antes en Zummo Ext WARRANTY (pageextension 50065)
                field("Technical Visit"; "Technical Visit")
                {

                }
                field(Response; Response)
                {
                    trigger OnDrillDown()
                    begin
                        Message(StrSubstNo('%1\%2', Rec.Response, Rec."Response Text"));
                    end;
                }
                field("Service Order"; "Service Order")
                {
                    Visible = UserHQ;
                }
                field("Credit Memo No."; "Credit Memo No.")
                {
                    Visible = UserHQ;
                }
                field("Cost Total"; "Cost Total")
                {
                    Visible = UserHQ;
                }
                field("Items No."; "Items No.")
                {
                    Visible = UserHQ;
                }
                field(SalerOrdersWS; SalerOrdersWS)
                {
                    Caption = 'Sales Order Line Items No.';
                    Visible = UserHQ;
                    trigger OnDrillDown()
                    begin
                        LookupSalerOrdersWS();
                    end;
                }
                field(SalerOrdersPVP; SalerOrdersPVP)
                {
                    Caption = 'Amount';
                    Visible = UserHQ;
                }
                field(SalerOrdersCost; SalerOrdersCost)
                {
                    Caption = 'Costs';
                    Visible = UserHQ;
                }
                field("Actiont Type"; "Actiont Type")
                {
                    ApplicationArea = ALl;
                }
                field(Resolution; Resolution)
                {
                    ApplicationArea = All;
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
        // Antes en Zummo Ext WARRANTY (pageextension 50065)
        area(processing)
        {
            action(CreateWarrantyInfo)
            {
                ApplicationArea = All;
                Caption = 'Create Order';
                Image = Order;
                promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = not SeleccServWarrant;

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
            action(CreateCustomer)
            {
                ApplicationArea = All;
                Caption = 'Create Customer';
                Visible = SeleccServWarrant;
                Image = NewCustomer;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label 'Do you want Create New Customer';
                begin
                    if Confirm(lblConfirm) then
                        Rec.CreateCustomer();
                end;
            }
            action(AssingCustomer)
            {
                ApplicationArea = All;
                Caption = 'Assing Customer';
                Visible = SeleccServWarrant;
                Image = Customer;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AssingCustomer_Action();
                end;
            }
            action("Export Excel")
            {
                ApplicationArea = All;
                // Visible = NotCustomerNo;
                Image = Excel;
                trigger OnAction()
                var
                    ServiceWarrantyHdr: Record "LGX ZMO Service & Warranty Hdr";
                    ZMFunctions: Codeunit "ZM Event Suscriber";
                begin
                    CurrPage.SetTableView(ServiceWarrantyHdr);
                    ZMFunctions.ExportExcelServiceWarranty(ServiceWarrantyHdr);
                end;
            }
        }
        area(navigation)
        {
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
                    SalesOrderList.SetTableView(SalesInvoiceHdr);
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

    // Antes en Zummo Ext WARRANTY (pageextension 50065)
    trigger OnOpenPage()
    begin
        if Rec.UserPermissionsstatistics() then
            UserHQ := true;
    end;

    trigger OnAfterGetRecord()
    begin
        NotCustomerNo := false;
        if SeleccServWarrant and (Rec."LGX ZMO Sell-To Customer No." = '') then
            NotCustomerNo := true;
        CalcSalerOrdersWS();
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        SalerOrdersWS: Integer;
        SalerOrdersPVP: Decimal;
        SalerOrdersCost: Decimal;
        NotCustomerNo: Boolean;
        SeleccServWarrant: Boolean;
        UserHQ: Boolean;


    procedure SetSeleccServWarrant()
    begin
        SeleccServWarrant := true;
    end;

    local procedure CalcSalerOrdersWS()
    begin
        Rec.CalculateSalerOrdersWS(SalerOrdersWS, SalerOrdersPVP, SalerOrdersCost);
    end;

    local procedure LookupSalerOrdersWS();
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("External Document No.", '%1', '*' + Rec."LGX ZMO Incident No." + '*');
        page.RunModal(0, SalesHeader);
    end;

    local procedure AssingCustomer_Action()
    var
        Customer: Record Customer;
        CustomerList: Page "Customer List";
        Filtertext: Text;
        lblMessage: Label 'Customer %1 assigned.';
    begin
        Rec.TestField("LGX ZMO Sell-To Customer No.", '');
        // Filtertext := ConvertStr(Rec."LGX ZMO Sell-to Customer Name", '()', '**');
        // Customer.SetFilter(Name, '%1', Filtertext);
        // CustomerList.SetTableView(Customer);
        CustomerList.LookupMode(true);
        if not (CustomerList.RunModal() = Action::LookupOK) then
            exit;
        CustomerList.GetRecord(Customer);
        Rec."LGX ZMO Sell-To Customer No." := Customer."No.";
        Rec.Modify();
        Message(lblMessage, Customer.Name);
    end;
}
