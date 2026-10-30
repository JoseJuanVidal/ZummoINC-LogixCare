page 50019 "Warranty & Service Items Hdr"
{
    Caption = 'Warranty & Service Info Items';
    PageType = Card;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "LGX ZMO Service & Warranty Hdr";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(WarrantyServicesInfo)
            {
                Caption = 'Warranty & Services Info';

                field("LGX ZMO Incident No."; "LGX ZMO Incident No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("LGX ZMO Warranty"; "LGX ZMO Warranty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Cotization Date"; "Cotization Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("LGX ZMO Item No."; "LGX ZMO Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("LGX ZMO Serial No."; "LGX ZMO Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Service Type"; "Service Type")
                {
                    TableRelation = "ZM Service Order Type".Code where(Type = const("Service Order Type"));

                    // trigger OnValidate()
                    // begin
                    //     UpdateFault();
                    // end;
                }
                field(Fault; Fault)
                {
                    TableRelation = "ZM Service Order Type".Code where(Type = const(Fault));
                }
                field("Localized Fault"; "Localized Fault")
                {
                }
            }

            part(Items; "ZM Service & Warranty Items")
            {
                Caption = 'Items';
                ApplicationArea = All;
                SubPageLink = "LGX ZMO Incident No." = field("LGX ZMO Incident No.");
                UpdatePropagation = Both;
            }
            group(Amounts)
            {
                field("Items Amount"; "Items Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DiscountPorc; DiscountPorc)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount Discount"; "Amount Discount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount Charges"; Rec.GetTotalsCharges())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Taxes; Taxes)
                {
                    ApplicationArea = All;
                }
                field("Amount Taxes"; "Amount Taxes")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Total; Rec.GetTotals())
                {
                    ApplicationArea = All;
                    Editable = False;
                }
            }
            grid(Charges)
            {
                GridLayout = Columns;
                group(ServiceCompany)
                {
                    ShowCaption = false;
                    field("Service Company"; "Service Company")
                    {
                        ApplicationArea = All;
                    }
                }
                grid(Shippings)
                {
                    GridLayout = Rows;
                    ShowCaption = false;


                    group(Shipping)
                    {
                        Caption = 'Shipping';
                        field("Shipphing Method"; "Shipphing Method")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }

                        field("Shipping Amount"; "Shipping Amount")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                }
                Grid(ChargesGrid)
                {
                    GridLayout = Rows;
                    Caption = 'Labors';
                    ShowCaption = false;

                    Group(Labors)
                    {
                        ShowCaption = false;

                        field("Labor Hours Quantity"; "Labor Hours Quantity")
                        {
                            ApplicationArea = All;
                            Caption = 'Quantity';

                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }

                        field("Labor Hours Fees"; "Labor Hours Fees")
                        {
                            ApplicationArea = All;
                            Caption = 'Amount';

                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Labor Hours"; "Labor Hours Quantity" * "Labor Hours Fees")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Labor';
                            Editable = false;
                        }
                    }
                }
                Grid(ChargeTravelssGrid)
                {
                    GridLayout = Rows;
                    Caption = 'Travels';
                    ShowCaption = false;

                    group(Travels)
                    {
                        ShowCaption = false;
                        field("Travel Hours Quantity"; "Travel Hours Quantity")
                        {
                            ApplicationArea = All;
                            Caption = 'Quantity';

                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Travel Hours Fees"; "Travel Hours Fees")
                        {
                            ApplicationArea = All;
                            Caption = 'Amount';

                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Travel Hours"; "Travel Hours Quantity" * "Travel Hours Fees")
                        {
                            ApplicationArea = All;
                            Caption = 'Total';
                            Editable = false;
                        }
                    }
                }
                grid(Other)
                {
                    GridLayout = Columns;
                    ShowCaption = false;
                    group(Others)
                    {
                        ShowCaption = false;
                        field("Credit Card Fees"; "Credit Card Fees")
                        {
                            ApplicationArea = All;
                        }
                        field("Rush Fees"; "Rush Fees")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }
        area(FactBoxes)
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
        area(Reporting)
        {
            action(PrintWarrServ)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ZMOServiceWarrantyHdr: Record "LGX ZMO Service & Warranty Hdr";
                    ReportWarrantyService: report "LGX ZMO Warranty & Service";
                begin
                    ZMOServiceWarrantyHdr.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
                    ReportWarrantyService.SetTableView(ZMOServiceWarrantyHdr);
                    ReportWarrantyService.Run();
                end;
            }
            action(PrintReturnWarrServ)
            {
                Caption = 'Print RMA';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ZMOServiceWarrantyHdr: Record "LGX ZMO Service & Warranty Hdr";
                    ReportWarrantyService: report "LGX ZMO Warranty & Service RMA";
                begin
                    ZMOServiceWarrantyHdr.SetRange("LGX ZMO Incident No.", Rec."LGX ZMO Incident No.");
                    ReportWarrantyService.SetTableView(ZMOServiceWarrantyHdr);
                    ReportWarrantyService.Run();
                end;
            }
        }
        area(Processing)
        {
            action(OrdersSendbyEmail)
            {
                Caption = 'Sent to Operations';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OrdersSendbyEmail_Action();
                end;
            }
            action(OrdersRMASendbyEmail)
            {
                Caption = 'Sent RMA to Operations';
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReturnOrdersSendbyEmail_Action();
                end;
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage."W&S Doc. Attachment Factbox".page.SetRecNo(Rec."LGX ZMO Incident No.", UnlikedAttachment.TypeDoc::" ");
        CurrPage.DocAttachmentFactbox.page.SetRecNo(Rec."LGX ZMO Incident No.", UnlikedAttachment.TypeDoc::Customer);
    end;

    var
        UnlikedAttachment: Record "Unlinked Attachment";

    local procedure OrdersSendbyEmail_Action()
    var
        lblConfirm: Label '¿Do you want to send the email to Operations Department?';
    begin
        if Confirm(lblConfirm) then
            Rec.OrdersSendbyEmail();
    end;

    local procedure ReturnOrdersSendbyEmail_Action()
    var
        lblConfirm: Label '¿Do you want to send the email to Operations Department?';
    begin
        if Confirm(lblConfirm) then
            Rec.ReturnOrdersSendbyEmail();
    end;

}